#!/usr/bin/env -S nim r
import os
import osproc
import strformat
import strutils
import terminal
import rdstdin
import parseopt


const VERSION {.strdefine.} = ""

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

proc updateAlacritty(themeName: string) =
  echo "UPDATING ALACRITTY"
  let cfgDir = getCfg()
  let cfg = fmt"{cfgDir}/alacritty/alacritty.yml"
  let themeDest = fmt"{cfgDir}/alacritty/themes/_.theme.yml"
  let themeSrc = fmt"{cfgDir}/alacritty/themes/{themeName}.theme.yml"

  # perm update
  removeFile(themeDest)
  createSymlink(themeSrc, themeDest)
  let declarations = getThemerDeclarations(readFile(themeDest))
  writeFile(cfg, insertThemerDeclarations(readFile(cfg), declarations))


proc updateTermite(themeName: string) =
  echo "UPDATING TERMITE"
  let cfgDir = getCfg()
  let cfg = fmt"{cfgDir}/termite/config"
  let themeDest = fmt"{cfgDir}/termite/themes/_.theme.conf"
  let themeSrc = fmt"{cfgDir}/termite/themes/{themeName}.theme.conf"

  # perm update
  removeFile(themeDest)
  createSymlink(themeSrc, themeDest)
  let declarations = getThemerDeclarations(readFile(themeDest))
  writeFile(cfg, insertThemerDeclarations(readFile(cfg), declarations))

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
      discard execCmd(fmt"kitty @ --to=unix:{path} set-colors -a {themeDest}")

proc updateVscode(themeName: string) =
  echo "UPDATING VSCODE"
  let cfgDir = getCfg()
  let cfg = fmt"{cfgDir}/Code/User/settings.json"

  let realThemeName = case themeName:
    of "nord":
      "Nord"
    of "dracula":
      "Dracula"
    else:
      echo "INVALID THEME"
      "Nord"

  # const cmd = &"file=\"/home/edwin/config/Code/User/settings.json\" content=\"$(cat \"$file\" | jq --arg theme \"Nord\" '.[\"workbench.colorTheme\"] = $theme')\"; cat >| \"$file\" <<< \"$content\""
  # discard execCmd(&"/bin/bash \"{cmd}\"")



proc updatei3(themeName: string) =
  echo "UPDATING i3"
  let cfgDir = getCfg()
  let themeSrc = fmt"{cfgDir}/i3/themes/{themeName}.theme.conf"
  let themeDest = fmt"{cfgDir}/i3/themes/_.theme.conf"
  let cfg = fmt"{cfgDir}/i3/config"

  # perm update
  removeFile(themeDest)
  createSymlink(themeSrc, themeDest)
  let declarations = getThemerDeclarations(readFile(themeDest))
  writeFile(cfg, insertThemerDeclarations(readFile(cfg), declarations))

  # live update
  discard execCmd("i3 reload")

proc updateRofi(themeName: string) =
  echo "UPDATING ROFI"
  let cfgDir = getCfg()
  let themeSrc = fmt"{cfgDir}/rofi/themes/{themeName}.theme.rasi"
  let themeDest = fmt"{cfgDir}/rofi/themes/_.theme.rasi"
  let cfg = fmt"{cfgDir}/rofi/config.rasi"

  # perm update
  removeFile(themeDest)
  createSymlink(themeSrc, themeDest)

proc writeHelp() =
  echo "--theme, --program"

proc writeVersion() =
  echo VERSION

proc doProgram(programName: string, theme: string) =
  case programName:
  of "xterm":
    updateXResources(theme) # broken
  of "alacritty":
    updateTermite(theme)
  of "kitty":
    updateKitty(theme)
  of "i3":
    updatei3(theme)
  of "rofi":
    updateRofi(theme)

proc readTheme(): string =
  var theme = ""
  if isatty(stdin):
    theme = readLineFromStdin("New theme?: ")
  else:
    theme = readAll(stdin)
  theme = theme.strip()
  if theme == "":
    echo "Theme not valid"
    quit(QuitFailure)

var theme = ""
var program = ""
var p = initOptParser(commandLineParams())
while true:
  p.next()
  case p.kind:
  of cmdEnd: break
  of cmdShortOption, cmdLongOption:
    case p.key
      of "help", "h": writeHelp(); quit QuitSuccess
      of "version", "v": writeVersion(); quit QuitSuccess
      of "program":
        program = p.val
      of "theme":
        theme = p.val
  of cmdArgument:
    echo "Argument: ", p.key

if theme == "":
  theme = readTheme()

if program != "":
  doProgram(program, theme)
  quit QuitSuccess

updateXResources(theme) # broken
updateAlacritty(theme)
updateTermite(theme)
updateKitty(theme)
# updateVscode(theme) # broken
updatei3(theme)
updateRofi(theme)
