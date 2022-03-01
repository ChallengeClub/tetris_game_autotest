#!/bin/bash -x

function do_game(){

    local LEVEL="${1}"
    local USER_NAME_BRANCH="${2}"
    local UNAME=`echo ${USER_NAME_BRANCH} | cut -d'@' -f1`
    local BRANCH=`echo ${USER_NAME_BRANCH} | cut -d'@' -f2`
    local WINDOW_X="${3}"
    local WINDOW_Y="${4}"
    local IMAGE_WINDOW_X="${5}"
    local IMAGE_WINDOW_Y="${6}"
    local SCORE_WINDOW_X="${7}"
    local SCORE_WINDOW_Y="${8}"

    local LOGFILE="~/tmp/resultlog_${UNAME}.json"
    local GAME_TIME=10
    local RANDOM_SEED=111
    local PROGRAM_NAME="sample_program"

    # prepare
    TETRIS_DIR="~/tmp/tetris_dir"
    mkdir -p ${TETRIS_DIR}
    pushd ${TETRIS_DIR}
    rm -rf tetris
    git clone https://github.com/${UNAME}/tetris -b ${BRANCH}
    popd

    local COMMAND="source ~/venvtest/bin/activate && \
	    cd ${TETRIS_DIR}/tetris && \
	    python3 start.py -l ${LEVEL} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE}"

    # start sound

    
    # start game
    gnome-terminal -- bash -c "${COMMAND}" &
    # download github profile image
    curl https://avatars.githubusercontent.com/${UNAME} --output "${UNAME}.png"
    convert -resize 160x "${UNAME}.png" "${UNAME}2.png"
    python image.py -u ${UNAME} -i "${UNAME}2.png" &
    python score.py -u ${UNAME} -p ${PROGRAM_NAME} -l ${LEVEL} -f ${LOGFILE} &
    sleep 2

    # adjust window
    ## adjust tetris window
    local WINDOW_NAME="Tetris_${UNAME}"
    WINDOWID=`xdotool search --onlyvisible --name "${WINDOW_NAME}"`
    xdotool windowmove ${WINDOWID} ${WINDOW_X} ${WINDOW_Y} &

    ## adjust image window
    local IMAGE_WINDOW_NAME="Image_${UNAME}"
    IMAGE_WINDOWID=`xdotool search --onlyvisible --name "${IMAGE_WINDOW_NAME}"`
    xdotool windowmove ${IMAGE_WINDOWID} ${IMAGE_WINDOW_X} ${IMAGE_WINDOW_Y} &

    ## adjust score window
    local SCORE_WINDOW_NAME="Score_${UNAME}"
    SCORE_WINDOWID=`xdotool search --onlyvisible --name "${SCORE_WINDOW_NAME}"`
    xdotool windowmove ${SCORE_WINDOWID} ${SCORE_WINDOW_X} ${SCORE_WINDOW_Y} &

    # sleep until game end
    sleep ${GAME_TIME}
    # show result

    return 0
}

function do_game_main(){

    LEVEL=${1}
    UNAME1=${2}
    UNAME2=${3}
    do_game ${LEVEL} "seigot" 350 150
    do_game ${LEVEL} "isshy-you" 700 150
}

echo "start"

#do_game 1 "sampleA" "sampleB"
#do_game 2 "seigot" 500 150 100 50 200 300
do_game 2 "isshy-you@master" 500 150 100 50 200 300

#do_game 2 "seigot" 350 150 100 100 300 100





echo "end"


