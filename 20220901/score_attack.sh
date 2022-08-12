#!/bin/bash -x

source common_command.sh

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
    local MODE=`echo ${USER_NAME_BRANCH} | cut -d'@' -f4`
    local PREDICT_WEIGHT=`echo ${USER_NAME_BRANCH} | cut -d'@' -f5`
    local DROP_SPEED="${3}"
    local WINDOW_X="${4}"
    local WINDOW_Y="${5}"
    local IMAGE_WINDOW_X="${6}"
    local IMAGE_WINDOW_Y="${7}"
    local SCORE_WINDOW_X="${8}"
    local SCORE_WINDOW_Y="${9}"

    local LOGFILE="${CURRENT_DIR}/resultlog_${UNAME}.json"
    local SCORE_LIST_FILE="${CURRENT_DIR}/scorelistfile_${UNAME}.txt"
    local GAME_TIME=180 #180
    local GAME_WAITTIME=30 #30
    local RANDOM_SEED=2022090111111
    if [ "${LEVEL}" == "1" ]; then
	RANDOM_SEED=0
    fi
    #local PROGRAM_NAME="sample_program"

    # sound name
    local SOUND_NUMBER=`echo $((RANDOM%+3))` # 0-2 random value
    #local SOUND_NUMBER=`echo $(( $[SOUND_NUMBER] % ${#SOUNDFILE_LIST[@]} ))`
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
    rm -f ${LOGFILE}
    rm -f ${SCORE_LIST_FILE}

    ###### wait game -->
    WAIT_TIME=${GAME_WAITTIME}
    python score.py -u ${UNAME} -p ${PROGRAM_NAME} -b ${BRANCH} -m ${MODE} -w ${PREDICT_WEIGHT} -l ${LEVEL} -t ${WAIT_TIME}
    ###### wait game <--
    # start sound
    play ${SOUNDFILE_PATH} &
    PID_PLAY_SOUND=$!
    # start image
    eog ${IMAGE_NAME} &
    
    # start game
    local EXEC_COMMAND=`GET_COMMAND ${LEVEL} ${DROP_SPEED} ${GAME_TIME} ${RANDOM_SEED} ${UNAME} ${LOGFILE} ${TETRIS_DIR} ${MODE} ${PREDICT_WEIGHT}`
    local COMMAND="source ~/venvtest/bin/activate && \
	    cd ${TETRIS_DIR}/tetris && \
	    ${EXEC_COMMAND}"

    # download github profile image
    curl https://avatars.githubusercontent.com/${UNAME} --output "${UNAME}.png"
    convert -resize 160x "${UNAME}.png" "${UNAME}2.png"
    bash -c "${COMMAND}" &
    python score.py -u ${UNAME} -p ${PROGRAM_NAME} -b ${BRANCH} -m ${MODE} -w ${PREDICT_WEIGHT} -l ${LEVEL} -f ${LOGFILE} -e ${WAIT_TIME} -s ${SCORE_LIST_FILE} --use_elapsed_time True &
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
    xdotool windowmove ${WINDOWID} 900 100 &

    # sleep until game end
    sleep ${GAME_TIME}

    # wait finish
    wait ${PID_PLAY_SOUND}

    # kill image
    bash stop.sh

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
    WAIT_TIME=${GAME_WAITTIME}
    ## display/adjust scorelist image
    DISPLAY_OUTPUTFILE="display_graph.png"
    python display_graph.py --file1 ${SCORE_LIST_FILE} --outputfile "tmp.png"
    convert -resize 640x480 "tmp.png" ${DISPLAY_OUTPUTFILE}
    eog ${DISPLAY_OUTPUTFILE} &
    sleep 1
    local DISPLAYSCORE_WINDOW_NAME=`basename ${DISPLAY_OUTPUTFILE}`
    WINDOWID=`xdotool search --onlyvisible --name "${DISPLAYSCORE_WINDOW_NAME}"`
    xdotool windowmove ${WINDOWID} 500 150
    ## diplay score
    python score.py -u ${UNAME} -p ${PROGRAM_NAME} -m ${MODE} -w ${PREDICT_WEIGHT} -l ${LEVEL} -f ${LOGFILE} -t ${WAIT_TIME}
    ## kil display
    pkill "eog"
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
    if [ "${LEVEL}" == "1" ]; then
	REPOSITORY_LIST=(
	    # "user_name @ branch_name @ program_name @ mode @ predict_weight"
	    "bushio@master@testname@predict_sample@weight/DQN/sample_weight.pt"
	    "seigot@master@testname@predict_sample2@weight/MLP/sample_weight.pt"
	    "AtsutoshiNaraki@master@testname@default@default"
	    "0829Rinoue@master@testname@default@default"
	    "cookie4869@master@testname@default@default"
	    "isshy-you@master@testname@default@default"
	    "jap-kmk@master@testname@default@default"
	    "Jumpeipei@master@testname@default@default"
	    "kodamanfamily@master@testname@default@default"
	    "koro298@master@testname@default@default"
	    "koubG@master@testname@default@default"
	    "krymt28@master@testname@default@default"
	    "n-nooobu@master@testname@default@default"
	    "n-yasunami@master@testname@default@default"
	    "nabehiko0523@master@testname@default@default"
	    "obo-koki@master@testname@default@default"
	    "qbi-sui@master@testname@default@default"
	    "RogerTokunaga@master@testname@default@default"
	    "ryochinbo@master@testname@default@default"
	    "skyblueline8@master@testname@default@default"
	    "sota1111@master@testname@default@default"
	    "taika-izumi@master@testname@default@default"
	    "yuta002@master@testname@default@default"
	    "zaki1010@master@testname@default@default"
	    "TsuchiyaYosuke@master@testname@default@default"
	    "mattshamrock@master@testname@default@default"
	    "usamin24@master@testname@default@default"
	    "yuin0@master@testname@default@default"
	)
    elif [ "${LEVEL}" == "2" ]; then
	REPOSITORY_LIST=(
#	    "mattshamrock@master@高まるフォイ"
#	    "usamin24@Lv2@チョコ&レート2号"
#	    "isshy-you@ish05c@いっしー5号"
	    "mattshamrock@master@高まるフォイ"
	    "usamin24@Lv2@チョコ&レート2号改"
	    "isshy-you@ish05h3@いっしー5号ぷらす"
	    "yuin0@tetris_second@CrackedEgg_v1.9"
	    "4321623@v2.0@勇者ちゃん2号"
	)
    elif [ "${LEVEL}" == "2_ai" ]; then
	LEVEL="2"
	REPOSITORY_LIST=(
	    "neteru141@master@たいちとだいち４号"
	    "EndoNrak@submit1@bushioさんありがとう"
	    "bushio@submit_level2@AIでテトリス"
#	    "seigot@master@neteru141さんリスペクトAI"
	)
    elif [ "${LEVEL}" == "3" ]; then
	REPOSITORY_LIST=(
	    "usamin24@Lv3@チョコ&レート3号"
	    "isshy-you@ish05h3@いっしー5号ぷらす"
	    "yuin0@tetris_second@CrackedEgg_v1.9"
	    "bushio@submit_level3@AIでテトリス"
	    "mattshamrock@master@困るフォイ"
	)
    elif [ "${LEVEL}" == "3_ryuo" ]; then
	LEVEL="3"
	DROP_SPEED=1
	REPOSITORY_LIST=(
	    "bushio@submit_level3@AIでテトリス"
	    "isshy-you@ish05c@いっしー5号"
	    "usamin24@Lv3@チョコ&レート3号"
	)
    elif [ "${LEVEL}" == "777" ]; then
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
#do_game_main 777

# level1
do_game_main 1

# level2
#do_game_main 2

# level2(AI)
#do_game_main "2_ai"

# level3
#do_game_main 3

# level3(3_ryuo)
#do_game_main "3_ryuo"

echo "end"


