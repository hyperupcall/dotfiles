#!/usr/bin/env sh

tmpdir="$(mktemp -d)"

# TODO: /home/edwin
diff /etc/profile.d/jre.sh /home/edwin/.dots/diffs/jre.sh > "$tmpdir/jre.diff"
patch /etc/profile.d/jre.sh "$tmpdir/jre.diff"

diff /etc/profile.d/servo.sh /home/edwin/.dots/diffs/jre.sh > "$tmpdir/servo.diff"
patch /etc/profile.d/servo.sh "$tmpdir/servo.diff"
