#!/usr/bin/env -S nim r
import os
import osproc
import strformat
import strutils

proc getCfg(): string =
  if getEnv("XDG_CONFIG_HOME") != "":
    return getEnv("XDG_CONFIG_HOME")
  return joinPath(getEnv("HOME"), ".config")

proc updateXResources(themeName: string) =
  let cfg = getCfg()

  removeFile(fmt"{cfg}/X11/themes/_.theme.Xresources")
  createSymlink(fmt"{cfg}/X11/themes/{themeName}.theme.Xresources", fmt"{cfg}/X11/themes/_.theme.Xresources")

  discard execCmd("xrdb -load ~/config/X11/Xresources")


proc updateTermite(themeName: string) =
  proc getKeyValue(str: string, separator: char): array[2, string] =
    let lr = split(str, separator)
    return [ strip(lr[0]), strip(lr[1]) ]

  let cfg = getCfg()
  let themeFrom = expandTilde(fmt"{cfg}/termite/themes/{themeName}.theme.conf")
  let themeTo = expandTilde(fmt"{cfg}/termite/config")

  var keyValueList: seq[string]
  for line in split(readFile(themeFrom), sep = '\n'):
    if line == "": continue
    if line.startsWith("#"): continue
    if not line.contains('='): continue

    let kv = getKeyValue(line, '=')
    keyValueList.add(fmt"{kv[0]} = {kv[1]}")

  var newThemeToArr: seq[string]
  var mode = "add"

  for line in split(readFile(themeTo), sep = '\n'):
    if mode == "add":
      newThemeToArr.add(line)

      if line == "# THEMER-BEGIN":
        mode = "skip"
        continue
    elif mode == "insert":
      for l in keyValueList:
        newThemeToArr.add(l)
      # must have newline so elif mode == "skip" changes to insert mode
      # has a next line for insert mode to actually happen
      newThemeToArr.add("# THEMER-END\n")
      mode = "add"
    elif mode == "skip":
      if line == "# THEMER-END":
        mode = "insert"

  writeFile(themeTo, join(newThemeToArr, "\n"))
  discard execCmd("killall -USR1 termite")

const theme = "nord"
updateXResources(theme)
updateTermite(theme)
