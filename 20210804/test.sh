#!/bin/bash -x
SOUNDFILE_LIST=(
    "~/Downloads/technotris.wav"
    "~/Downloads/troika.wav"
    "~/Downloads/kalinka.wav"
)

SOUND_NUMBER=4
SOUND_NUMBER=`echo $(( $[SOUND_NUMBER] % ${#SOUNDFILE_LIST[@]} ))`

echo $SOUND_NUMBER
