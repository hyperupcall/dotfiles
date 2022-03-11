#!/usr/bin/env python
# https://gitlab.com/wsha/chorded_keymap/-/blob/master/print_events.py

"""Simple tool for watching what keyboard events are being generated.

Usage: intercept $DEVNODE | python print_events.py

Do not use -g on intercept -- that will swallow all keyboard input and this
script does not print it out in a way that can be used to keep keyboard input
working.
"""

# This source code is part of Chorded Keymap, a plugin for
# Interception Tools (https://gitlab.com/interception/linux/tools)
# that temporarily remaps the keyboard when a set of keys (a "chord")
# is pressed simultaneously.
#    Copyright (C) 2017 wsha

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA

import struct
import sys

# input_event struct format:
INPUT_EVENT = struct.Struct('llHHI')
EVENT_SECS = 0
EVENT_USECS = 1
EVENT_TYPE = 2
EVENT_CODE = 3
EVENT_VALUE = 4

# Key type
EV_KEY = 1

# Key codes
VAL_RELEASE = 0
VAL_PRESS = 1
VAL_REPEAT = 2

# Key values
KEY_S = 31
KEY_D = 32
KEY_H = 35
KEY_J = 36
KEY_K = 37
KEY_L = 38
KEY_UP = 103
KEY_LEFT = 105
KEY_RIGHT = 106
KEY_DOWN = 108
CHORD_KEYS = (KEY_S, KEY_D)
CHORD_MAP = {KEY_H: KEY_LEFT,
             KEY_J: KEY_DOWN,
             KEY_K: KEY_UP,
             KEY_L: KEY_RIGHT}

MODE_DEFAULT = 0
MODE_CHORD = 1
MODE_TRIGGER = 2

keys_down = 0
event_buffer = []
mode = MODE_DEFAULT
KEYS_DOWN = [False, False]

while True:
    data = sys.stdin.buffer.read(INPUT_EVENT.size)
    event_in = INPUT_EVENT.unpack(data)
    print(event_in)
