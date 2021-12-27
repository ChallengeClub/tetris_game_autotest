#!/bin/bash

function do_game(){

    USER_NAME_A="${1}" #"sampleA"
    USER_NAME_B="${2}" #"sampleB"

    GAME_TIME=20
    RANDOM_SEED=111
    COMMAND_A="cd ~/tetris && python3 start.py -s y -l 2 -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${USER_NAME_A}"
    COMMAND_B="cd ~/tetris && python3 start.py -s y -l 2 -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${USER_NAME_B}"

    # start game
    gnome-terminal -- bash -c "${COMMAND_A}" &
    gnome-terminal -- bash -c "${COMMAND_B}" &
    sleep 1

    # adjust window
    WINDOW_NAME_A="Tetris_${USER_NAME_A}"
    WINDOW_NAME_B="Tetris_${USER_NAME_B}"
    WINDOWID_A=`xdotool search --onlyvisible --name "${WINDOW_NAME_A}"`
    WINDOWID_B=`xdotool search --onlyvisible --name "${WINDOW_NAME_B}"`
    xdotool windowmove ${WINDOWID_A} 350 150 &
    xdotool windowmove ${WINDOWID_B} 700 150 &

    # sleep until game end
    sleep ${GAME_TIME}
}
do_game "sampleA" "sampleB"

echo "end"


