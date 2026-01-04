#!/usr/bin/env bash
set -euo pipefail

SLUG="$1"
URL="$2"
MODEL="${MODEL:-models/ggml-base.en.bin}"

TMPDIR=$(mktemp -d)
trap 'rm -rf $TMPDIR' EXIT

curl -sL "$URL" -o "$TMPDIR/audio.mp3"
ffmpeg -i "$TMPDIR/audio.mp3" -ar 16000 -ac 1 "$TMPDIR/audio.wav" -y -loglevel error
whisper-cli -m "$MODEL" -ovtt -of "$TMPDIR/out" "$TMPDIR/audio.wav" 2>/dev/null
mv "$TMPDIR/out.vtt" "transcripts/$SLUG.vtt"
