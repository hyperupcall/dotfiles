#!/bin/sh -eu

curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o ~/.local/.bin/n

curl -L -o- https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s - latest
