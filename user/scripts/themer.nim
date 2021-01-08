#!/usr/bin/env -S nim r
import os
import osproc
import strformat
import strutils

proc getCfg(): string =
  if getEnv("XDG_CONFIG_HOME") != "":
    return getEnv("XDG_CONFIG_HOME")
  return joinPath(getEnv("HOME"), ".config")

proc getRuntimeDir(): string =
  if getEnv("XDG_RUNTIME_DIR") != "":
    return getEnv("XDG_RUNTIME_DIR")
  raise newException(Defect, "XDG_RUNTIME_DIR not found")

proc getThemerDeclarations(fileContent: string): seq[string] =
  const comment = "#"
  var declarations: seq[string] = @[]

  var n = 1
  while true:
    let startSubstr = &"{comment} THEMER-BEGIN-{n}\n"
    let startIndex = find(fileContent, startSubstr)

    let endSubstr = &"{comment} THEMER-END-{n}\n"
    let endIndex = find(fileContent, endSubstr)

    if startIndex == -1 or endIndex == -1:
      return declarations

    let catch = fileContent[startIndex + len(startSubstr) .. endIndex - 2]
    declarations.add(catch)

    n = n + 1

  return declarations

proc insertThemerDeclarations(originalFileContent: string, declarations: seq[string]): string =
  const comment = "#"
  var fileContent = originalFileContent

  var n = 1
  while true:
    let startSubstr = &"{comment} THEMER-BEGIN-{n}\n"
    let startIndex = find(fileContent, startSubstr)

    let endSubstr = &"{comment} THEMER-END-{n}\n"
    let endIndex = find(fileContent, endSubstr)

    if startIndex == -1 or endIndex == -1:
      return fileContent

    let s = startIndex + len(startSubstr) - 1
    let e = endIndex - 1
    fileContent = fileContent[0 .. s] & declarations[n - 1] & fileContent[e .. ^1]
    n = n + 1

  return fileContent


# update*
proc updateXResources(themeName: string) =
  echo "UPDATING XRESOURCES"
  let cfgDir = getCfg()
  let cfg = fmt"{cfgDir}/X11/Xresources"
  let themeDest = fmt"{cfgDir}/X11/themes/_.theme.Xresources"
  let themeSrc = fmt"{cfgDir}/X11/themes/{themeName}.theme.Xresources"

  # perm update
  removeFile(themeDest)
  createSymlink(themeSrc, themeDest)
  discard execCmd(fmt"xrdb -load {cfg}")

  # live update

proc updateTermite(themeName: string) =
  echo "UPDATING TERMITE"
  let cfgDir = getCfg()
  let cfg = fmt"{cfgDir}/termite/config"
  let themeDest = fmt"{cfgDir}/termite/themes/_.theme.conf"
  let themeSrc = fmt"{cfgDir}/termite/themes/{themeName}.theme.conf"

  # perm update
  let declarations = getThemerDeclarations(readFile(themeDest))
  writeFile(cfg, insertThemerDeclarations(readFile(cfg), declarations))
  removeFile(themeDest)
  createSymlink(themeSrc, themeDest)

  # live update
  discard execCmd("killall -USR1 termite")

proc updateKitty(themeName: string) =
  echo "UPDATING KITTY"
  let cfgDir = getCfg()
  let themeDest = fmt"{cfgDir}/kitty/themes/_.theme.conf"
  let themeSrc = fmt"{cfgDir}/kitty/themes/{themeName}.theme.conf"

  # perm update
  removeFile(themeDest)
  createSymlink(themeSrc, themeDest)

  # live update (requires launching via ~/scripts/kitty.sh)
  for kind, path in walkDir(joinPath(getRuntimeDir(), "kitty")):
    if count(path, "control-socket-") > 0:
      discard execCmd(fmt"kitty @ --to=unix:{path} set-colors -a {cfgDir}/kitty/themes/_.theme.conf")

proc updatei3(themeName: string) =
  echo "UPDATING i3"
  let cfgDir = getCfg()
  let themeSrc = fmt"{cfgDir}/i3/themes/{themeName}.theme.conf"
  let themeDest = fmt"{cfgDir}/i3/themes/_.theme.conf"
  let cfg = fmt"{cfgDir}/i3/config"

  # perm update
  let declarations = getThemerDeclarations(readFile(themeDest))
  writeFile(cfg, insertThemerDeclarations(readFile(cfg), declarations))
  removeFile(themeDest)
  createSymlink(themeSrc, themeDest)

  # live update
  discard execCmd("i3 reload")


const theme = "dracula"
updateXResources(theme) # broken
updateTermite(theme)
updateKitty(theme)
updatei3(theme)
