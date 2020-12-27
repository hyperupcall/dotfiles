#!/usr/bin/env -S nim --hints:off

mode = ScriptMode.Silent
packageName = "Dot Reconciler"
version = "1.0.0"
author = "Edwin Kofler"
description = "Reconcile dot programs"

proc do_bootstrap() =
  echo "boostrap"

proc do_misc() =
  echo "misc"

proc do_info() =
  exec "lstopo"

if paramCount() < 3:
  echo "Error(2): Requires subcommand"
  quit 2

case paramStr(3):
of "":
  echo "Error: Requres subcommand"
  quit 2
of "bootstrap":
  do_bootstrap()
of "misc":
  do_misc()
of "info":
  do_info()
else:
  echo "Error: Unknown Command"
  quit 2
