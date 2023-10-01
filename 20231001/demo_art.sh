#!/bin/bash -x

CURRENT_DIR=`pwd`

function func_exec_command(){
    local TETRIS_DIR="${CURRENT_DIR}/tetris_dir"
    CONFIG_NAME=${1}
    DURATION=${2}
    USER_NAME=${3}

    local EXEC_COMMAND_00="python start.py -m art -l1 --art_config_filepath config/art/${CONFIG_NAME} -d ${DURATION} -u ${USER_NAME}"
    echo "EXEC_COMMAND(1):${EXEC_COMMAND_00}"
    local COMMAND="source ~/venv/python3.10-test/bin/activate && 
	    cd ${TETRIS_DIR}/tetris_seigot && \
	    ${EXEC_COMMAND_00}"
    bash -c "${COMMAND}" &
}

function func_exec_command_2(){
    local TETRIS_DIR="${CURRENT_DIR}/tetris_dir"
    CONFIG_NAME=${1}
    DURATION=${2}
    USER_NAME=${3}

    local EXEC_COMMAND_00="python start.py -m art -l1 --art_config_filepath config/art/${CONFIG_NAME} -d ${DURATION} -u ${USER_NAME}"
    echo "EXEC_COMMAND(1):${EXEC_COMMAND_00}"
    local COMMAND="source ~/venv/python3.10-test/bin/activate && 
	    cd ${TETRIS_DIR}/tetris_mattshamrock_2 && \
	    ${EXEC_COMMAND_00}"
    bash -c "${COMMAND}" &
}

function func_exec_command_3(){
    local TETRIS_DIR="${CURRENT_DIR}/tetris_dir"
    CONFIG_NAME=${1}
    DURATION=${2}
    USER_NAME=${3}

    local EXEC_COMMAND_00="python start.py -m art -l1 --art_config_filepath config/art/${CONFIG_NAME} -d ${DURATION} -u ${USER_NAME} --BlockNumMax 1000"
    echo "EXEC_COMMAND(1):${EXEC_COMMAND_00}"
    local COMMAND="source ~/venv/python3.10-test/bin/activate && 
	    cd ${TETRIS_DIR}/tetris_seigot_2 && \
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
    local WINDOW_00_X=100
    local WINDOW_01_X=450
    local WINDOW_02_X=800
    local WINDOW_03_X=1150    
    local WINDOW_04_X=1500
    local WINDOW_05_X=1850
    local WINDOW_06_X=2200
    local WINDOW_07_X=2550
    local WINDOW_08_X=2900
    local WINDOW_00_Y=200
    local WINDOW_01_Y=300
    local WINDOW_10_Y=800

    local GAME_TIME=180

    # uname1
    pushd tetris_dir/tetris_${UNAME}
    git pull
    git checkout ${BRANCH} 
    popd

    # start game
    func_exec_command_3 "art_config_sample16.json" "80" "art_00"
#    func_exec_command "art_config_sample4.json" "1000" "art_00"
    func_exec_command "art_config_sample_e.json" "1000" "art_01"
    func_exec_command "art_config_sample_n.json" "1000" "art_02"
    func_exec_command "art_config_sample_j.json" "1000" "art_03"
    func_exec_command "art_config_sample_o.json" "1000" "art_04"
    func_exec_command "art_config_sample_y.json" "1000" "art_05"
    func_exec_command_2 "squirtle.json" "80" "art_06"
    func_exec_command_2 "bulbasaur.json" "80" "art_07"
#    func_exec_command "art_config_sample_fireflower.json" "1000" "art_06"
#    func_exec_command "art_config_sample_tanaka_2.json" "1000" "art_07"
    func_exec_command_3 "art_config_sample17.json" "80" "art_10"
    func_exec_command "art_config_sample_m.json" "1000" "art_11"
    func_exec_command "art_config_sample_f.json" "1000" "art_12"
    func_exec_command "art_config_sample_t.json" "1000" "art_13"
    func_exec_command "art_config_sample_o.json" "1000" "art_14"
    func_exec_command "art_config_sample_k.json" "1000" "art_15"
    func_exec_command "art_config_sample_y.json" "1000" "art_16"
    func_exec_command "art_config_sample_o.json" "1000" "art_17"
    func_exec_command "art_config_sample8.json" "1000" "art_18"
    func_exec_command_2 "pikachu.json" "150" "art_19"

    sleep 11 # 4sec for PC, 10sec for jetson nano, because of delay
   
    # adjust window
    ## adjust tetris window
    adjust_window "art_00" ${WINDOW_00_X} ${WINDOW_00_Y}
    adjust_window "art_01" ${WINDOW_01_X} ${WINDOW_00_Y}
    adjust_window "art_02" ${WINDOW_02_X} ${WINDOW_00_Y}
    adjust_window "art_03" ${WINDOW_03_X} ${WINDOW_00_Y}
    adjust_window "art_04" ${WINDOW_04_X} ${WINDOW_00_Y}
    adjust_window "art_05" ${WINDOW_05_X} ${WINDOW_00_Y}
    adjust_window "art_06" ${WINDOW_06_X} ${WINDOW_00_Y}
    adjust_window "art_07" ${WINDOW_07_X} ${WINDOW_00_Y}
    adjust_window "art_10" ${WINDOW_00_X} ${WINDOW_10_Y}
    adjust_window "art_11" ${WINDOW_01_X} ${WINDOW_10_Y}
    adjust_window "art_12" ${WINDOW_02_X} ${WINDOW_10_Y}
    adjust_window "art_13" ${WINDOW_03_X} ${WINDOW_10_Y}
    adjust_window "art_14" ${WINDOW_04_X} ${WINDOW_10_Y}
    adjust_window "art_15" ${WINDOW_05_X} ${WINDOW_10_Y}
    adjust_window "art_16" ${WINDOW_06_X} ${WINDOW_10_Y}
    adjust_window "art_17" ${WINDOW_07_X} ${WINDOW_10_Y}
    adjust_window "art_18" ${WINDOW_08_X} ${WINDOW_10_Y}
    adjust_window "art_19" ${WINDOW_08_X} ${WINDOW_00_Y}
    
    sleep 87
    return 0
}

function do_game2(){

    local UNAME="seigot"
    local BRANCH="art20230728"

    # window coordinate
    local WINDOW_00_X=100
    local WINDOW_01_X=450
    local WINDOW_02_X=800
    local WINDOW_03_X=1150    
    local WINDOW_04_X=1500
    local WINDOW_05_X=1850
    local WINDOW_06_X=2200
    local WINDOW_07_X=2550
    local WINDOW_08_X=2900
    local WINDOW_00_Y=200
    local WINDOW_01_Y=300
    local WINDOW_10_Y=800

    local GAME_TIME=180

    # uname1
    pushd tetris_dir/tetris_${UNAME}_2
    git pull
    git checkout ${BRANCH} 
    popd

    # start game
    func_exec_command_3 "art_config_sample30.json" "80" "art_00"
    func_exec_command_3 "art_config_sample31.json" "80" "art_01"
    func_exec_command_3 "art_config_sample11.json" "80" "art_02"
    func_exec_command_3 "art_config_sample12.json" "80" "art_03"
    func_exec_command_3 "art_config_sample18.json" "80" "art_04"
    func_exec_command_3 "art_config_sample19.json" "80" "art_05"
    func_exec_command_3 "art_config_sample25.json" "80" "art_06"
    func_exec_command_3 "art_config_sample26.json" "80" "art_07"
    func_exec_command_3 "art_config_sample27.json" "80" "art_19"
    func_exec_command_3 "art_config_sample32.json" "80" "art_10"
    func_exec_command_3 "art_config_sample33.json" "80" "art_11"
    func_exec_command_3 "art_config_sample10.json" "80" "art_12"
    func_exec_command_3 "art_config_sample23.json" "80" "art_13"
    func_exec_command_3 "art_config_sample20.json" "80" "art_14"
    func_exec_command_3 "art_config_sample21.json" "80" "art_15"
    func_exec_command_3 "art_config_sample24.json" "80" "art_16"
    func_exec_command_3 "art_config_sample14.json" "80" "art_17"
    func_exec_command_3 "art_config_sample15.json" "80" "art_18"

    sleep 11 # 4sec for PC, 10sec for jetson nano, because of delay
   
    # adjust window
    ## adjust tetris window
    adjust_window "art_00" ${WINDOW_00_X} ${WINDOW_00_Y}
    adjust_window "art_01" ${WINDOW_01_X} ${WINDOW_00_Y}
    adjust_window "art_02" ${WINDOW_02_X} ${WINDOW_00_Y}
    adjust_window "art_03" ${WINDOW_03_X} ${WINDOW_00_Y}
    adjust_window "art_04" ${WINDOW_04_X} ${WINDOW_00_Y}
    adjust_window "art_05" ${WINDOW_05_X} ${WINDOW_00_Y}
    adjust_window "art_06" ${WINDOW_06_X} ${WINDOW_00_Y}
    adjust_window "art_07" ${WINDOW_07_X} ${WINDOW_00_Y}
    adjust_window "art_10" ${WINDOW_00_X} ${WINDOW_10_Y}
    adjust_window "art_11" ${WINDOW_01_X} ${WINDOW_10_Y}
    adjust_window "art_12" ${WINDOW_02_X} ${WINDOW_10_Y}
    adjust_window "art_13" ${WINDOW_03_X} ${WINDOW_10_Y}
    adjust_window "art_14" ${WINDOW_04_X} ${WINDOW_10_Y}
    adjust_window "art_15" ${WINDOW_05_X} ${WINDOW_10_Y}
    adjust_window "art_16" ${WINDOW_06_X} ${WINDOW_10_Y}
    adjust_window "art_17" ${WINDOW_07_X} ${WINDOW_10_Y}
    adjust_window "art_18" ${WINDOW_08_X} ${WINDOW_10_Y}
    adjust_window "art_19" ${WINDOW_08_X} ${WINDOW_00_Y}
    
    sleep 140
    return 0
}


echo "start"
# infinity loop
while true
do
    bash stop.sh
    sleep 1
    do_game
    bash stop.sh
    sleep 1
    do_game2
done
echo "end"
