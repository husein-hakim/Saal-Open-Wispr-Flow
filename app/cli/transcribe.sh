#!/bin/bash

AUDIO_FILE="recording.wav"
RAW_TXT="raw.txt"
FINAL_TXT="final.txt"

echo "Recording... press Control+C to stop."

rec -r 16000 -c 1 "$AUDIO_FILE"

echo "Transcribing..."

../../engine/whisper.cpp/build/bin/whisper-cli \
  -m ../../engine/whisper.cpp/models/ggml-base.en.bin \
  -f "$AUDIO_FILE" \
  -otxt \
  -of raw \
  -nt

echo "Raw transcript:"
cat "$RAW_TXT"

RAW_TEXT=$(cat "$RAW_TXT")

../../engine/llama.cpp/build/bin/llama-cli \
-m ../../models/qwen2.5-1.5b-instruct-q4_k_m.gguf \
--no-conversation \
-p "You are a text rewriting engine.

Rewrite the text using proper grammar and punctuation.

Rules:
- Preserve meaning exactly.
- Do not add information.
- Do not explain.
- Do not comment.
- Output only the rewritten text.

Text:

$RAW_TEXT" \
> "$FINAL_TXT"

echo ""
echo "Final rewritten text:"
cat "$FINAL_TXT"

pbcopy < "$FINAL_TXT"

echo ""
echo "Copied rewritten text to clipboard."
