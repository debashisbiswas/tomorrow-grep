#!/usr/bin/env bash
set -euo pipefail

MODEL="models/ggml-base.en.bin"
MODEL_URL="https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin"

mkdir -p transcripts models

if [ ! -f "$MODEL" ]; then
    echo "Downloading model..."
    curl -L "$MODEL_URL" -o "$MODEL"
fi

export MODEL
./fetch_feed.py | parallel -j2 --colsep '\t' ./transcribe.sh {1} {2}
