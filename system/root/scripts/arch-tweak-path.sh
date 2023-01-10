#!/usr/bin/env sh

diffsDir="/home/edwin/.dotfiles/diffs"
tmpdir="$(mktemp -d)"

diff /etc/profile.d/jre.sh "$diffsDir/jre.sh" > "$tmpdir/jre.diff"
patch /etc/profile.d/jre.sh "$tmpdir/jre.diff"

diff /etc/profile.d/servo.sh $diffsDir/jre.sh > "$tmpdir/servo.diff"
patch /etc/profile.d/servo.sh "$tmpdir/servo.diff"
