#!/bin/bash -x

function GET_COMMAND(){

    LEVEL=${1}
    DROP_SPEED=${2}
    GAME_TIME=${3}
    RANDOM_SEED=${4}
    UNAME=${5}
    LOGFILE=${6}
    TETRIS_DIR=${7}

    if [ "${UNAME}" == "seigot" ]; then
	EXEC_COMMAND="python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE}"
    else
	EXEC_COMMAND="python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE}"
    fi

    echo ${EXEC_COMMAND}
}


