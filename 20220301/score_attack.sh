#!/bin/bash -x

# prepare following files
#  - ~/Downloads/technotris.wav,troika.wav,kalinka.wav
#  - ~/Downloads/megen1-12.jpg"

# ffmpeg -i *.mp4 -ac 1 *.wav
# ffmpeg -i *.mp3 *.wav
SOUNDFILE_LIST=(
    "~/Downloads/technotris.wav"
    "~/Downloads/troika.wav"
    "~/Downloads/kalinka.wav"
)

CURRENT_DIR=`pwd`
RESULT_LOG="${CURRENT_DIR}/result.log"

function do_game(){

    local LEVEL="${1}"
    local USER_NAME_BRANCH="${2}"
    local UNAME=`echo ${USER_NAME_BRANCH} | cut -d'@' -f1`
    local BRANCH=`echo ${USER_NAME_BRANCH} | cut -d'@' -f2`
    local PROGRAM_NAME=`echo ${USER_NAME_BRANCH} | cut -d'@' -f3`
    local DROP_SPEED="${3}"
    local WINDOW_X="${4}"
    local WINDOW_Y="${5}"
    local IMAGE_WINDOW_X="${6}"
    local IMAGE_WINDOW_Y="${7}"
    local SCORE_WINDOW_X="${8}"
    local SCORE_WINDOW_Y="${9}"

    local LOGFILE="${HOME}/tmp/resultlog_${UNAME}.json"
    local GAME_TIME=180
    local RANDOM_SEED=1111
    #local PROGRAM_NAME="sample_program"

    # sound name
    local SOUND_NUMBER=`echo $(( $[SOUND_NUMBER] % ${#SOUNDFILE_LIST[@]} ))`
    local SOUNDFILE_PATH=${SOUNDFILE_LIST[$SOUND_NUMBER]}
    # image name
    local IMAGE_NUMBER=`echo $((RANDOM%+13))` # 0-12 random value
    local IMAGE_NAME="${HOME}/Downloads/megen${IMAGE_NUMBER}.jpg"

    # prepare
    TETRIS_DIR="${HOME}/tmp/tetris_dir"
    mkdir -p ${TETRIS_DIR}
    pushd ${TETRIS_DIR}
    rm -rf tetris
    echo ${UNAME} ${BRANCH}
    git clone https://github.com/${UNAME}/tetris -b ${BRANCH}
    ## additional setting -->
    ## xxx
    ## additional setting <--
    popd

    ###### wait game -->
    WAIT_TIME=30
    python score.py -u ${UNAME} -p ${PROGRAM_NAME} -l ${LEVEL} -t ${WAIT_TIME}
    ###### wait game <--

    # start sound
    play ${SOUNDFILE_PATH} &
    PID_PLAY_SOUND=$!
    # start image
    eog ${IMAGE_NAME} &
    
    # start game
    local COMMAND="source ~/venvtest/bin/activate && \
	    cd ${TETRIS_DIR}/tetris && \
	    python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE}"
    #gnome-terminal -- bash -c "${COMMAND}" &
    # download github profile image
    curl https://avatars.githubusercontent.com/${UNAME} --output "${UNAME}.png"
    convert -resize 160x "${UNAME}.png" "${UNAME}2.png"
    bash -c "${COMMAND}" &
    python score.py -u ${UNAME} -p ${PROGRAM_NAME} -l ${LEVEL} -f ${LOGFILE} &
    python image.py -u ${UNAME} -i "${UNAME}2.png" &
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

    ## adjust meigen image
    local MEIGEN_WINDOW_NAME=`basename ${IMAGE_NAME}`
    WINDOWID=`xdotool search --onlyvisible --name "${MEIGEN_WINDOW_NAME}"`
    xdotool windowmove ${WINDOWID} 900 100

    # sleep until game end
    sleep ${GAME_TIME}

    # wait finish
    wait ${PID_PLAY_SOUND}

    # kill image
    bash stop.sh
    pkill "eog"

    # show result
    SCORE=`jq .judge_info.score ${LOGFILE}`
    LINE_CNT=`jq .judge_info.line ${LOGFILE}`
    GAMEOVER_CNT=`jq .judge_info.gameover_count ${LOGFILE}`
    _1LINE_CNT=`jq .debug_info.line_score_stat[0] ${LOGFILE}`
    _2LINE_CNT=`jq .debug_info.line_score_stat[1] ${LOGFILE}`
    _3LINE_CNT=`jq .debug_info.line_score_stat[2] ${LOGFILE}`
    _4LINE_CNT=`jq .debug_info.line_score_stat[3] ${LOGFILE}`
    RESULT_STR="${UNAME}, ${PROGRAM_NAME}, ${LEVEL}, ${SCORE}, ${LINE_CNT}, ${GAMEOVER_CNT}, ${_1LINE_CNT}, ${_2LINE_CNT}, ${_3LINE_CNT}, ${_4LINE_CNT}"

    #echo ${RESULT_STR}
    echo ${RESULT_STR} >> ${RESULT_LOG}
    echo ${RESULT_STR} >> ${RESULT_LEVEL_LOG}
    echo " ---- Current Score ranking(TOP5), LEVEL ${LEVEL} ----"
    sort -k 4nr -t , ${RESULT_LEVEL_LOG} | head -5
    echo " ----"

    ###### wait game -->
    WAIT_TIME=30
    python score.py -u ${UNAME} -p ${PROGRAM_NAME} -l ${LEVEL} -f ${LOGFILE} -t ${WAIT_TIME}
    ###### wait game <--
    
    # show result
    return 0
}

function do_game_main(){
    LEVEL=${1} # 1
    DROP_SPEED=1000
    #UNAME=${2} # "isshy-you@master@isshy-program"

    # create empty file
    RESULT_LEVEL_LOG="${HOME}/result_level${LEVEL}.log"
    echo -n >| ${RESULT_LEVEL_LOG}
    echo -n >| ${RESULT_LOG}

    # get repository list
    # format
    #   repository_name@branch@free_string
    if [ ${LEVEL} == 1 ]; then    
	REPOSITORY_LIST=(
	    "seigot@master@せいご-program"
	    "isshy-you@master@isshy-program"
	)
    elif [ ${LEVEL} == 2 ]; then	
	REPOSITORY_LIST=(
	    "seigot@master@せいご-program"
	    "isshy-you@master@isshy-program"
	)
    elif [ ${LEVEL} == "2_ai" ]; then	
	LEVEL="2"
	REPOSITORY_LIST=(
	    "seigot@master@せいご-program"
	    "isshy-you@master@isshy-program"
	)
    elif [ ${LEVEL} == 3 ]; then	
	REPOSITORY_LIST=(
	    "seigot@master@せいご-program"
	    "isshy-you@master@isshy-program"
	)
    elif [ ${LEVEL} == "3_ryuo" ]; then
	LEVEL="3"
	DROP_SPEED=1
	REPOSITORY_LIST=(
	    "seigot@master@せいご-program"
	    "isshy-you@master@isshy-program"
	)
    elif [ ${LEVEL} == 777 ]; then
	# forever branch
	REPOSITORY_LIST=(
	    "kyad@forever-branch@無限テトリス"
	)
    else
	echo "invalid level ${LEVEL}"
	return
    fi

    #if [ ${LEVEL} == "777" ];then
    #LEVEL="1"
    #fi

    # main loop
    for (( i = 0; i < ${#REPOSITORY_LIST[@]}; i++ ))
    do
	echo ${REPOSITORY_LIST[$i]}
	do_game ${LEVEL} ${REPOSITORY_LIST[$i]} ${DROP_SPEED} 500 150 100 50 200 300
    done
}

echo "start"

# level777
# do_game_main 777

# level1
do_game_main 1

# level2
do_game_main 2

# level2(AI)
do_game_main "2_ai"

# level3
do_game_main 3

# level3(3_ryuo)
do_game_main "3_ryuo"

echo "end"


