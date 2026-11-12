#!/usr/bin/env bats

load ../vendor/bats-all/load.bash

setup() {
	mkdir -p "$BATS_TEST_TMPDIR/bin" "$BATS_TEST_TMPDIR/work" "$BATS_TEST_TMPDIR/tmp"
	export PATH="$BATS_TEST_TMPDIR/bin:$PATH"
	export TMPDIR="$BATS_TEST_TMPDIR/tmp"
	export TO_OPUS_ENCODER_LOG="$BATS_TEST_TMPDIR/encoder.log"

	cat >"$BATS_TEST_TMPDIR/bin/ffmpeg" <<'EOF'
#!/usr/bin/env bash
if [[ " $* " == *' -f wav '* ]]; then
	if [ "${TO_OPUS_FFMPEG_FAIL:-0}" = 1 ] || [ "$2" = "${TO_OPUS_FAIL_INPUT:-}" ]; then
		exit 42
	fi
	printf 'wav fixture'
elif [ "${TO_OPUS_COVER:-0}" = 1 ]; then
	printf 'cover fixture' >"${@: -1}"
fi
EOF
	cat >"$BATS_TEST_TMPDIR/bin/ffprobe" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
	cat >"$BATS_TEST_TMPDIR/bin/opusenc" <<'EOF'
#!/usr/bin/env bash
cat >/dev/null
printf '%s\n' "$*" >>"$TO_OPUS_ENCODER_LOG"
printf 'encoded fixture' >"${@: -1}"
exit "${TO_OPUS_ENCODER_STATUS:-0}"
EOF
	chmod +x "$BATS_TEST_TMPDIR/bin/"*
	cd "$BATS_TEST_TMPDIR/work"
}

assert_no_temporary_files() {
	run find "$TMPDIR" -mindepth 1 -print
	assert_output ''
	run find . -maxdepth 1 -name '*.tmp.*' -print
	assert_output ''
}

@test "to-opus publishes successful audio without cover art" {
	printf 'input fixture' >'song title.mp4'
	run "$BATS_TEST_DIRNAME/../bin/to-opus" 'song title.mp4'
	assert_success
	assert_output 'Done: song title.opus'
	assert_equal "$(cat 'song title.opus')" 'encoded fixture'
	assert_no_temporary_files
}

@test "to-opus passes available cover art to the encoder" {
	export TO_OPUS_COVER=1
	printf 'input fixture' >song.mp4
	run "$BATS_TEST_DIRNAME/../bin/to-opus" song.mp4
	assert_success
	run cat "$TO_OPUS_ENCODER_LOG"
	assert_output --partial '--picture'
	assert_no_temporary_files
}

@test "to-opus fails and removes partial output when decoding fails" {
	export TO_OPUS_FFMPEG_FAIL=1
	printf 'input fixture' >song.mp4
	run "$BATS_TEST_DIRNAME/../bin/to-opus" song.mp4
	assert_failure
	assert_output --partial 'Error: conversion failed: song.mp4'
	refute_output --partial 'Done:'
	assert [ ! -e song.opus ]
	assert_no_temporary_files
}

@test "to-opus fails and removes partial output when encoding fails" {
	export TO_OPUS_ENCODER_STATUS=31
	printf 'input fixture' >song.mp4
	run "$BATS_TEST_DIRNAME/../bin/to-opus" song.mp4
	assert_failure
	refute_output --partial 'Done:'
	assert [ ! -e song.opus ]
	assert_no_temporary_files
}

@test "to-opus preserves an existing output" {
	printf 'input fixture' >song.mp4
	printf 'existing output' >song.opus
	run "$BATS_TEST_DIRNAME/../bin/to-opus" song.mp4
	assert_failure
	assert_equal "$(cat song.opus)" 'existing output'
	assert_no_temporary_files
}

@test "to-opus continues a batch but reports any conversion failure" {
	export TO_OPUS_FAIL_INPUT=bad.mp4
	printf 'input fixture' >bad.mp4
	printf 'input fixture' >good.mp4
	run "$BATS_TEST_DIRNAME/../bin/to-opus" bad.mp4 good.mp4
	assert_failure
	assert_output --partial 'Done: good.opus'
	assert [ ! -e bad.opus ]
	assert [ -f good.opus ]
	assert_no_temporary_files
}

@test "to-opus cleans up when publishing the output fails" {
	printf '#!/usr/bin/env bash\nexit 1\n' >"$BATS_TEST_TMPDIR/bin/mv"
	chmod +x "$BATS_TEST_TMPDIR/bin/mv"
	printf 'input fixture' >song.mp4
	run "$BATS_TEST_DIRNAME/../bin/to-opus" song.mp4
	assert_failure
	assert_output --partial 'Error: could not save output: song.opus'
	assert [ ! -e song.opus ]
	assert_no_temporary_files
}
