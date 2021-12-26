#!/bin/bash


GAME_TIME=10
RANDOM_SEED=111
USER_NAME_A="sampleA"
USER_NAME_B="sampleB"
COMMAND_A="cd ~/tetris && python3 start.py -s y -l 2 -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${USER_NAME_A}"
COMMAND_B="cd ~/tetris && python3 start.py -s y -l 2 -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${USER_NAME_B}"
gnome-terminal -- bash -c "${COMMAND_A}" &
gnome-terminal -- bash -c "${COMMAND_B}" &
sleep 1
WINDOWID_A=`xdotool search --onlyvisible --name "${USER_NAME_A}"`
WINDOWID_B=`xdotool search --onlyvisible --name "${USER_NAME_B}"`
xdotool windowmove ${WINDOWID_A} 350 150 &
xdotool windowmove ${WINDOWID_B} 700 150 &
sleep ${GAME_TIME}

echo "end"


