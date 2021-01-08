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

proc insertThemerDeclarations(file: string, declarations: seq[string]): string =
  const comment = "#"
  var fileContent = readFile(file)

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
  # perm update
  let cfg = getCfg()
  let dest = fmt"{cfg}/X11/themes/_.theme.Xresources"
  let src = fmt"{cfg}/X11/themes/{themeName}.theme.Xresources"
  removeFile(dest)
  createSymlink(src, dest)

  # live update
  discard execCmd("xrdb -load ~/config/X11/Xresources")

proc updateTermite(themeName: string) =
  proc getKeyValue(str: string, separator: char): array[2, string] =
    let lr = split(str, separator)
    return [ strip(lr[0]), strip(lr[1]) ]

  let cfg = getCfg()
  let dest = fmt"{cfg}/termite/themes/_.theme.conf"
  let src = fmt"{cfg}/termite/themes/{themeName}.theme.conf"
  removeFile(dest)
  createSymlink(src, dest)

  let declarations = getThemerDeclarations(readFile(fmt"{cfg}/termite/themes/_.theme.conf"))
  let newFile = insertThemerDeclarations(fmt"{cfg}/termite/config", declarations)
  writeFile(fmt"{cfg}/termite/config", newFile)
  # let themeFrom = fmt"{cfg}/termite/themes/{themeName}.theme.conf"
  # let themeTo = fmt"{cfg}/termite/config"

  # var keyValueList: seq[string]
  # for line in split(readFile(themeFrom), sep = '\n'):
  #   if line == "": continue
  #   if line.startsWith("#"): continue
  #   if not line.contains('='): continue

  #   let kv = getKeyValue(line, '=')
  #   keyValueList.add(fmt"{kv[0]} = {kv[1]}")

  # var newThemeToArr: seq[string]
  # var mode = "add"

  # for line in split(readFile(themeTo), sep = '\n'):
  #   if mode == "add":
  #     newThemeToArr.add(line)

  #     if line == "# THEMER-BEGIN":
  #       mode = "skip"
  #       continue
  #   elif mode == "insert":
  #     for l in keyValueList:
  #       newThemeToArr.add(l)
  #     # must have newline so elif mode == "skip" changes to insert mode
  #     # has a next line for insert mode to actually happen
  #     newThemeToArr.add("# THEMER-END\n")
  #     mode = "add"
  #   elif mode == "skip":
  #     if line == "# THEMER-END":
  #       mode = "insert"

  # writeFile(themeTo, join(newThemeToArr, "\n"))

  # live update
  discard execCmd("killall -USR1 termite")

proc updateKitty(themeName: string) =
  let cfg = getCfg()
  removeFile(fmt"{cfg}/kitty/themes/_.theme.conf")
  createSymlink(fmt"{cfg}/kitty/themes/{themeName}.theme.conf", fmt"{cfg}/kitty/themes/_.theme.conf")

  for kind, path in walkDir(joinPath(getRuntimeDir(), "kitty")):
    if count(path, "control-socket-") > 0:
      discard execCmd(fmt"kitty @ --to=unix:{path} set-colors -a {cfg}/kitty/themes/_.theme.conf")

proc updatei3(themeName: string) =
  let cfg = getCfg()
  let themeFrom = fmt"{cfg}/i3/themes/{themeName}.theme.conf"
  let themeTo = fmt"{cfg}/i3/config"
  removeFile(fmt"{cfg}/i3/themes/_.theme.conf")
  createSymlink(fmt"{cfg}/i3/themes/{themeName}.theme.conf", fmt"{cfg}/i3/themes/_.theme.conf")

  let declarations = getThemerDeclarations(readFile(fmt"{cfg}/i3/themes/_.theme.conf"))
  let newDeclarations = insertThemerDeclarations(themeTo, declarations)
  writeFile(themeTo, newDeclarations)


const theme = "dracula"
updateXResources(theme)
updateTermite(theme)
updateKitty(theme)
updatei3(theme)
