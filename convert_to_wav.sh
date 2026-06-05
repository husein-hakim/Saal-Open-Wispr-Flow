#!/bin/bash

for file in benchmarks/test_audio/*.m4a
do
    output="${file%.m4a}.wav"

    echo "Converting $file -> $output"

    ffmpeg -y \
        -i "$file" \
        -ar 16000 \
        -ac 1 \
        "$output"
done

echo "Done!"

