#!/bin/sh

count=0
bn=$2

for f in $(cat $1);
do
    idx=$(printf "%03d" $count)
    basename=$idx"_"$bn
#   aws polly synthesize-speech --output-format ogg_vorbis --voice-id Mizuki --text $f voice/$basename.ogg
   aws polly synthesize-speech --output-format mp3 --voice-id Mizuki --text $f voice/$basename.mp3

    echo $basename
    let count++
done
