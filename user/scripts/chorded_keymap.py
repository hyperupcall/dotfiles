#!/usr/bin/env python
"""Chorded keymap plugin for interception tools"""

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

import select
import struct
import sys
import time

# input_event struct format:
INPUT_EVENT = struct.Struct('llHHI')
EVENT_SECS = 0
EVENT_USECS = 1
EVENT_TYPE = 2
EVENT_CODE = 3
EVENT_VALUE = 4

# Key type
EV_SYN = 0
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

CHORD_TIMEOUT = 0.2

keys_down = 0
event_buffer = []
mode = MODE_DEFAULT
pressed_chord_key = None
trigger_key = None
trigger_timeout_time = None


def read_event_batch(max_time):
    if max_time is not None:
        # Make sure an unexpected delay doesn't give a negative timeout
        timeout = max(0.05, max_time - time.time())
    else:
        timeout = None
    rlist, _, _ = select.select([sys.stdin], [], [], timeout)

    full_event = []
    key_event_index = -1
    key_event = (None, None, None, None, None)
    if rlist:
        event = (None, None, None, None, None)
        event_index = -1
        while event[EVENT_TYPE] != EV_SYN:
            event_index = event_index + 1

            data = sys.stdin.buffer.read(INPUT_EVENT.size)
            full_event.append(data)

            event = INPUT_EVENT.unpack(data)
            if event[EVENT_TYPE] == EV_KEY:
                if key_event_index == -1:
                    key_event_index = event_index
                    key_event = event
                else:
                    raise RuntimeError(
                        'Multiple key events received in a single SYN batch.')

    return (full_event, key_event_index, key_event)


start_time = time.time()
while True:
    (full_event,
     key_event_index,
     key_event) = read_event_batch(trigger_timeout_time)

    if key_event_index == -1:
        for event in event_buffer:
            sys.stdout.buffer.write(event)
        sys.stdout.buffer.flush()
        event_out = full_event
        mode = MODE_DEFAULT
        trigger_key = None
        trigger_timeout_time = None
    elif mode == MODE_DEFAULT:
        try:
            key_index = CHORD_KEYS.index(key_event[EVENT_CODE])
        except ValueError:
            key_index = -1
        if key_index != -1 and key_event[EVENT_VALUE] == VAL_PRESS:
            mode = MODE_TRIGGER
            keys_down = keys_down + 1
            event_buffer += full_event
            pressed_chord_key = key_event[EVENT_CODE]
            trigger_key = CHORD_KEYS[(key_index + 1) % 2]
            event_out = None
            trigger_timeout_time = time.time() + CHORD_TIMEOUT
        else:
            event_out = key_event
    elif mode == MODE_CHORD:
        if key_event[EVENT_CODE] in CHORD_MAP:
            event_out = list(key_event)
            event_out[EVENT_CODE] = CHORD_MAP[key_event[EVENT_CODE]]
            event_out = tuple(event_out)
        elif key_event[EVENT_CODE] in CHORD_KEYS:
            if key_event[EVENT_VALUE] == VAL_RELEASE:
                mode = MODE_DEFAULT
                event_out = None
                keys_down = max(0, keys_down - 1)
            elif key_event[EVENT_VALUE] == VAL_PRESS:
                raise RuntimeError('Unexpected key press received')
            elif key_event[EVENT_VALUE] == VAL_REPEAT:
                # Eat repeat events for chord keys
                event_out = None
        else:
            event_out = key_event
    elif mode == MODE_TRIGGER:
        if (key_event[EVENT_VALUE] == VAL_PRESS and
                key_event[EVENT_CODE] == trigger_key):
            mode = MODE_CHORD
            keys_down = keys_down + 1
            event_out = None
            trigger_key = None
            pressed_chord_key = None
            trigger_timeout_time = None
        elif ((key_event[EVENT_VALUE] == VAL_REPEAT and
               key_event[EVENT_CODE] == pressed_chord_key) and
              time.time() < trigger_timeout_time):
            event_buffer += full_event
            event_out = None
        else:
            mode = MODE_DEFAULT
            event_out = key_event
            for event in event_buffer:
                sys.stdout.buffer.write(event)
            sys.stdout.buffer.flush()
            event_buffer = []
            trigger_key = None
            pressed_chord_key = None
            trigger_timeout_time = None

    if event_out:
        if event_out[EVENT_VALUE] == VAL_PRESS:
            keys_down = keys_down + 1
        elif event_out[EVENT_VALUE] == VAL_RELEASE:
            keys_down = max(0, keys_down - 1)

        full_event[key_event_index] = INPUT_EVENT.pack(*event_out)
        for event in full_event:
            sys.stdout.buffer.write(event)
        sys.stdout.buffer.flush()
