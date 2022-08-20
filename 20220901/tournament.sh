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
RESULT_LOG_DIR="${CURRENT_DIR}/result"
RESULT_LOG="${RESULT_LOG_DIR}/result.log"
RESULT_ALL_LOG="${RESULT_LOG_DIR}/result_all.log"

function do_game(){

    local LEVEL="${1}"
    local USER_NAME_BRANCH="${2}"
    local UNAME=`echo ${USER_NAME_BRANCH} | cut -d'@' -f1`
    local BRANCH=`echo ${USER_NAME_BRANCH} | cut -d'@' -f2`
    local PROGRAM_NAME=`echo ${USER_NAME_BRANCH} | cut -d'@' -f3`
    local MODE=`echo ${USER_NAME_BRANCH} | cut -d'@' -f4`
    local PREDICT_WEIGHT=`echo ${USER_NAME_BRANCH} | cut -d'@' -f5`
    local USER_NAME_BRANCH_2="${3}"
    local UNAME_2=`echo ${USER_NAME_BRANCH_2} | cut -d'@' -f1`
    local BRANCH_2=`echo ${USER_NAME_BRANCH_2} | cut -d'@' -f2`
    local PROGRAM_NAME_2=`echo ${USER_NAME_BRANCH_2} | cut -d'@' -f3`
    local MODE2=`echo ${USER_NAME_BRANCH_2} | cut -d'@' -f4`
    local PREDICT_WEIGHT2=`echo ${USER_NAME_BRANCH_2} | cut -d'@' -f5`
    local DROP_SPEED="${4}"

    # window coordinate
    # 350 150 0   0  50   300
    # 700 150 1200 50 1200 300
    local WINDOW_X=350
    local WINDOW_Y=150
    local IMAGE_WINDOW_X=0
    local IMAGE_WINDOW_Y=0
    local SCORE_WINDOW_X=50
    local SCORE_WINDOW_Y=300
    local WINDOW_X_2=700
    local WINDOW_Y_2=150
    local IMAGE_WINDOW_X_2=1200
    local IMAGE_WINDOW_Y_2=50
    local SCORE_WINDOW_X_2=1200
    local SCORE_WINDOW_Y_2=300
    local GRAPH_WINDOW_X=350
    local GRAPH_WINDOW_Y=150

    local TETRIS_DIR="${CURRENT_DIR}/tetris_dir"
    local LOGFILE="${RESULT_LOG_DIR}/resultlog_${UNAME}.json"
    local LOGFILE_2="${RESULT_LOG_DIR}/resultlog_${UNAME_2}.json"
    local SCORE_LIST_FILE="${RESULT_LOG_DIR}/scorelistfile_${UNAME}.txt"
    local SCORE_LIST_FILE_2="${RESULT_LOG_DIR}/scorelistfile_${UNAME_2}.txt"
    
    local GAME_TIME=180
    local EXTERNAL_SLEEP_TIME=30
    #local RANDOM_SEED=1111
    local RANDOM_SEED=${RANDOM}
    #local PROGRAM_NAME="sample_program"

    # sound name
    local SOUND_NUMBER=`echo $((RANDOM%+3))` # 0-2 random value
#    local SOUND_NUMBER=`echo $(( $[SOUND_NUMBER] % ${#SOUNDFILE_LIST[@]} ))`
    local SOUNDFILE_PATH=${SOUNDFILE_LIST[$SOUND_NUMBER]}

    # prepare
    mkdir -p ${TETRIS_DIR}
    pushd ${TETRIS_DIR}
    rm -rf tetris_${UNAME}
    rm -rf tetris_${UNAME_2}    
    echo ${UNAME} ${BRANCH}
    git clone https://github.com/${UNAME}/tetris -b ${BRANCH} tetris_${UNAME}
    git clone https://github.com/${UNAME_2}/tetris -b ${BRANCH_2} tetris_${UNAME_2}
    rm -f ${LOGFILE}
    rm -f ${LOGFILE_2}
    rm -f ${SCORE_LIST_FILE}
    rm -f ${SCORE_LIST_FILE_2}
    ## additional setting -->
    ## xxx
    ## additional setting <--
    popd

    ###### wait game -->
    WAIT_TIME=30
    python score.py -u ${UNAME_2} -p ${PROGRAM_NAME_2} -m ${MODE2} -w ${PREDICT_WEIGHT} -l ${LEVEL} -t ${WAIT_TIME} &
    sleep 1
    # move window
    local SCORE_WINDOW_NAME_2="Score_${UNAME_2}"
    SCORE_WINDOWID_2=`xdotool search --onlyvisible --name "${SCORE_WINDOW_NAME_2}"`
    xdotool windowmove ${SCORE_WINDOWID_2} 500 100 &
    python score.py -u ${UNAME} -p ${PROGRAM_NAME} -m ${MODE} -w ${PREDICT_WEIGHT2} -l ${LEVEL} -t ${WAIT_TIME}
    ###### wait game <--

    # start sound
    play ${SOUNDFILE_PATH} &
    PID_PLAY_SOUND=$!
    
    # start game
    local EXEC_COMMAND=`GET_COMMAND ${LEVEL} ${DROP_SPEED} ${GAME_TIME} ${RANDOM_SEED} ${UNAME} ${LOGFILE} ${TETRIS_DIR} ${MODE} ${PREDICT_WEIGHT}`
    local COMMAND="source ~/venvtest/bin/activate && \
	    cd ${TETRIS_DIR}/tetris_${UNAME} && \
	    ${EXEC_COMMAND}"
    local EXEC_COMMAND_2=`GET_COMMAND ${LEVEL} ${DROP_SPEED} ${GAME_TIME} ${RANDOM_SEED} ${UNAME_2} ${LOGFILE_2} ${TETRIS_DIR} ${MODE2} ${PREDICT_WEIGHT2}`
    local COMMAND_2="source ~/venvtest/bin/activate && \
	    cd ${TETRIS_DIR}/tetris_${UNAME_2} && \
	    ${EXEC_COMMAND_2}"

    #python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE}"
    #gnome-terminal -- bash -c "${COMMAND}" &
    # download github profile image
    curl https://avatars.githubusercontent.com/${UNAME} --output "${RESULT_LOG_DIR}/${UNAME}.png"
    convert -resize 160x "${RESULT_LOG_DIR}/${UNAME}.png" "${RESULT_LOG_DIR}/${UNAME}2.png"
    curl https://avatars.githubusercontent.com/${UNAME_2} --output "${RESULT_LOG_DIR}/${UNAME_2}.png"
    convert -resize 160x "${RESULT_LOG_DIR}/${UNAME_2}.png" "${RESULT_LOG_DIR}/${UNAME_2}2.png"    
    bash -c "${COMMAND}" &
    bash -c "${COMMAND_2}" &
    python score.py -u ${UNAME} -p ${PROGRAM_NAME} -b ${BRANCH} -m ${MODE} -w ${PREDICT_WEIGHT} -l ${LEVEL} -f ${LOGFILE} -e ${EXTERNAL_SLEEP_TIME} -s ${SCORE_LIST_FILE} --use_elapsed_time True &
    python image.py -u ${UNAME} -i "${RESULT_LOG_DIR}/${UNAME}2.png" &
    python score.py -u ${UNAME_2} -p ${PROGRAM_NAME_2} -b ${BRANCH_2} -w ${PREDICT_WEIGHT2} -m ${MODE2} -l ${LEVEL} -f ${LOGFILE_2} -e ${EXTERNAL_SLEEP_TIME} -s ${SCORE_LIST_FILE_2} --use_elapsed_time True &
    python image.py -u ${UNAME_2} -i "${RESULT_LOG_DIR}/${UNAME_2}2.png" &    
    sleep 2

    # adjust window
    ## adjust tetris window
    local WINDOW_NAME="Tetris_${UNAME}"
    WINDOWID=`xdotool search --onlyvisible --name "${WINDOW_NAME}"`
    xdotool windowmove ${WINDOWID} ${WINDOW_X} ${WINDOW_Y} &
    local WINDOW_NAME_2="Tetris_${UNAME_2}"
    WINDOWID_2=`xdotool search --onlyvisible --name "${WINDOW_NAME_2}"`
    xdotool windowmove ${WINDOWID_2} ${WINDOW_X_2} ${WINDOW_Y_2} &    

    ## adjust image window
    local IMAGE_WINDOW_NAME="Image_${UNAME}"
    IMAGE_WINDOWID=`xdotool search --onlyvisible --name "${IMAGE_WINDOW_NAME}"`
    xdotool windowmove ${IMAGE_WINDOWID} ${IMAGE_WINDOW_X} ${IMAGE_WINDOW_Y} &
    local IMAGE_WINDOW_NAME_2="Image_${UNAME_2}"
    IMAGE_WINDOWID_2=`xdotool search --onlyvisible --name "${IMAGE_WINDOW_NAME_2}"`
    xdotool windowmove ${IMAGE_WINDOWID_2} ${IMAGE_WINDOW_X_2} ${IMAGE_WINDOW_Y_2} &

    ## adjust score window
    local SCORE_WINDOW_NAME="Score_${UNAME}"
    SCORE_WINDOWID=`xdotool search --onlyvisible --name "${SCORE_WINDOW_NAME}"`
    xdotool windowmove ${SCORE_WINDOWID} ${SCORE_WINDOW_X} ${SCORE_WINDOW_Y} &
    local SCORE_WINDOW_NAME_2="Score_${UNAME_2}"
    SCORE_WINDOWID_2=`xdotool search --onlyvisible --name "${SCORE_WINDOW_NAME_2}"`
    xdotool windowmove ${SCORE_WINDOWID_2} ${SCORE_WINDOW_X_2} ${SCORE_WINDOW_Y_2} &

    # sleep until game end
    sleep ${GAME_TIME}

    # wait finish
    wait ${PID_PLAY_SOUND}

    # wait
    ## display/adjust scorelist image
    DISPLAY_OUTPUTFILE="${RESULT_LOG_DIR}/display_graph_${UNAME}_${UNAME_2}.png"
    TMP_FILE="tmp.png"    
    python display_graph.py --file1 ${SCORE_LIST_FILE} --file2 ${SCORE_LIST_FILE_2} --outputfile ${TMP_FILE}
    convert -resize 500x400 ${TMP_FILE} ${DISPLAY_OUTPUTFILE}
    rm ${TMP_FILE}
    eog ${DISPLAY_OUTPUTFILE} &
    sleep 1
    local DISPLAYSCORE_WINDOW_NAME=`basename ${DISPLAY_OUTPUTFILE}`
    WINDOWID=`xdotool search --onlyvisible --name "${DISPLAYSCORE_WINDOW_NAME}"`
    xdotool windowmove ${WINDOWID} ${GRAPH_WINDOW_X} ${GRAPH_WINDOW_Y}
    ## sleep..
    sleep ${EXTERNAL_SLEEP_TIME}

    # kill image
    bash stop.sh

    # show result
    DATE=`date '+%Y%m%d%H%m'`
    echo "-- $DATE" >> ${RESULT_ALL_LOG}
    echo "-- player1(${UNAME}) score" >> ${RESULT_ALL_LOG}
    jq .judge_info.score ${LOGFILE} >> ${RESULT_ALL_LOG}
    echo "-- player2(${UNAME_2}) score" >> ${RESULT_ALL_LOG}
    jq .judge_info.score ${LOGFILE_2} >> ${RESULT_ALL_LOG}
    tail -5 ${RESULT_ALL_LOG}

    return 0
}

function do_game_main(){

    echo -n >| ${RESULT_LOG}

    ## sample
    # "user_name @ branch_name @ program_name @ mode @ predict_weight"
    #PLAYER1="seigot@master@せいご-program@default@default"
    #PLAYER2="isshy-you@master@isshy-program@default@default"
    PLAYER1="bushio@master@testname@predict_sample@weight/DQN/sample_weight.pt"
    PLAYER2="seigot@master@testname@predict_sample2@weight/MLP/sample_weight.pt"
	    
    ## 2
#    PLAYER1="yuin0@tetris_second@CrackedEgg_v1.9@default@default"
#    PLAYER1="isshy-you@ish05h3@いっしー5号ぷらす@default@default"
#    PLAYER2="4321623@v2.0@勇者ちゃん2号@default@default"
#    PLAYER2="usamin24@Lv2@チョコ&レート2号改@default@default"
#    PLAYER2="mattshamrock@master@高まるフォイ@default@default"


    ## 2_ai
#    PLAYER1="bushio@submit_level2@AIでテトリス@default@default"
#    PLAYER1="EndoNrak@submit1@bushioさんありがとう@default@default"
#    PLAYER2="neteru141@master@たいちとだいち４号@default@default"

    ## 3(ai vs human)
#    PLAYER1="bushio@submit_level3@AIでテトリス@default@default"
#    PLAYER1="usamin24@Lv3@チョコ&レート3号@default@default"
#    PLAYER1="mattshamrock@master@困るフォイ@default@default"
#    PLAYER2="isshy-you@ish05h3@いっしー5号ぷらす@default@default"
#    PLAYER2="yuin0@tetris_second@CrackedEgg_v1.9@default@default"

    ## ryuo(ai vs human)
#    PLAYER1="bushio@submit_level3@AIでテトリス@default@default"
#    PLAYER2="isshy-you@ish05c@いっしー5号@default@default"
#    PLAYER2="usamin24@Lv3@チョコ&レート3号@default@default"

    #---
    LEVEL=3 #"2"
    DROP_SPEED="1"   #"1"#"1000"
    #---

    do_game ${LEVEL} ${PLAYER1} ${PLAYER2} ${DROP_SPEED}
}

echo "start"
do_game_main
echo "end"


