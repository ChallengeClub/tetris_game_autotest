#!/bin/bash -x

CURRENT_DIR=`pwd`

function func_exec_command(){
    local TETRIS_DIR="${CURRENT_DIR}/tetris_dir"
    CONFIG_NAME=${1}
    DURATION=${2}
    USER_NAME=${3}

    local EXEC_COMMAND_00="python start.py -m art -l1 --art_config_filepath config/art/${CONFIG_NAME} -d ${DURATION} -u ${USER_NAME} --BlockNumMax 1200"
    echo "EXEC_COMMAND(1):${EXEC_COMMAND_00}"
    local COMMAND="source ~/venv/python3.10-test/bin/activate && 
	    cd ${TETRIS_DIR}/tetris_seigot && \
	    ${EXEC_COMMAND_00}"
    bash -c "${COMMAND}" &
}

function adjust_window(){
    local NAME=${1}
    local WINDOW_X=${2}
    local WINDOW_Y=${3}
    local WINDOW_NAME="Tetris_${NAME}"
    WINDOWID=`xdotool search --onlyvisible --name "${WINDOW_NAME}"`
    xdotool windowmove ${WINDOWID} ${WINDOW_X} ${WINDOW_Y} &
}


function do_game(){

#    local LEVEL="${1}"
#    local USER_NAME_BRANCH="${2}"
    local UNAME="seigot"
    local BRANCH="master"

    # window coordinate
    #local WINDOW_00_X=100
    local WINDOW_01_X=150
    local WINDOW_02_X=370
    local WINDOW_03_X=750
    local WINDOW_04_X=970
    local WINDOW_00_Y=100

    local GAME_TIME=180

    # uname1
    pushd tetris_dir/tetris_${UNAME}
    git pull
    git checkout ${BRANCH} 
    popd

    # start game
    func_exec_command "art_config_sample39.json" "100" "art_01"
    func_exec_command "art_config_sample40.json" "100" "art_03"
    sleep 1
    func_exec_command "art_config_sample38.json" "100" "art_02"
    func_exec_command "art_config_sample41.json" "100" "art_04"

    sleep 5 # 4sec for PC, 10sec for jetson nano, because of delay
   
    # adjust window
    ## adjust tetris window
    adjust_window "art_01" ${WINDOW_01_X} ${WINDOW_00_Y}
    adjust_window "art_03" ${WINDOW_03_X} ${WINDOW_00_Y}
#    sleep 1
    adjust_window "art_02" ${WINDOW_02_X} ${WINDOW_00_Y}
    adjust_window "art_04" ${WINDOW_04_X} ${WINDOW_00_Y}
    
    sleep 87
    return 0
}

echo "start"

# infinity loop
while true
do
    bash stop.sh
    sleep 1
    do_game
done
echo "end"
