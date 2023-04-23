#!/bin/bash

function try_kill_process(){
    PROCESS_NAME=$1
    if [ -z "$PROCESS_NAME" ]; then
	return 0
    fi
    
    PROCESS_ID=`ps -e -o pid,cmd | grep ${PROCESS_NAME} | grep -v grep | awk '{print $1}'`
    if [ -z "$PROCESS_ID" ]; then
	echo "no process like... ${PROCESS_NAME}"
	return 0
    fi
    echo "kill process ... ${PROCESS_NAME}"
    #kill -SIGINT $PROCESS_ID
    kill $PROCESS_ID
}

function stop_process(){    
    try_kill_process "start.py"
    try_kill_process "game_manager.py"
    try_kill_process "gameserver.sh"
    try_kill_process "image.py"
    try_kill_process "score.py"
    try_kill_process "megen"
    try_kill_process "display_graph.py"
    try_kill_process "eog"
    try_kill_process "summary.py"
}

stop_process
