#!/bin/bash -x

echo "repository_name, level, score, line, gameover, 1line, 2line, 3line, 4line" > $RESULTLOG

CURRENT_DIR=`pwd`
TMP_LOG="${CURRENT_DIR}/tmp.log"
DISPLAY_PY="${CURRENT_DIR}/display.py"
RESULT_LOG="${CURRENT_DIR}/result.log"

# ffmpeg -i *.mp4 -ac 1 *.wav
# ffmpeg -i *.mp3 *.wav
SOUNDFILE_LIST=(
    "~/Downloads/technotris.wav"
    "~/Downloads/troika.wav"
    "~/Downloads/kalinka.wav"
)

# function
function do_game(){

    CLONE_REPOSITORY_LIST=(
	"http://github.com/kyad/tetris_game -b forever-branch"
	"http://github.com/yuin0/tetris_game -b feature/yuin0/improve-controller2"
	"http://github.com/hirov2/tetris_game"
#	"http://github.com/isshy-you/tetris_game"
    )

    echo "REPOSITORY_OWNER, LEVEL, SCORE" > ${RESULT_LOG}
    cd ~

    for (( i = 0; i < ${#CLONE_REPOSITORY_LIST[@]}; i++ ))
    do
	REPOSITORY_OWNER=`echo ${CLONE_REPOSITORY_LIST[$i]} | cut -d' ' -f1 | cut -d'/' -f4`
	LEVEL=1
	#SOUND_NUMBER=`echo $((RANDOM%+3))` # 0-2 random value
	SOUND_NUMBER=`echo $[i]`
	SOUND_NUMBER=`echo $(( $[SOUND_NUMBER] % ${#CLONE_REPOSITORY_LIST[@]} ))`
	SOUNDFILE_NAME=${SOUNDFILE_LIST[$SOUND_NUMBER]}

	if [ ${REPOSITORY_OWNER} == "kyad" ];then
	    LEVEL=777
	fi

	# prepare
	echo "git clone ${CLONE_REPOSITORY_LIST[$i]}"
	echo "REPOSITORY_OWNER: ${REPOSITORY_OWNER}"
	echo "LEVEL: ${LEVEL}"
	echo "RAND_NUMBER: ${RAND_NUMBER}"
	echo "SOUNDFILE_NAME: ${SOUNDFILE_NAME}"

        # main
	rm -rf tetris_game
	mkdir tetris_game
	git clone ${CLONE_REPOSITORY_LIST[$i]}
	pushd tetris_game
	play ${SOUNDFILE_NAME} &
	python3 ${DISPLAY_PY} --player_name ${REPOSITORY_OWNER} --level ${LEVEL} &
	bash start.sh -l${LEVEL} > ${TMP_LOG}
	sleep 2

	# get result
	SCORE=`grep "YOUR_RESULT" ${TMP_LOG} -2 | grep score | cut -d, -f1 | cut -d: -f2`
	LINE_CNT=`grep "YOUR_RESULT" ${TMP_LOG} -2 | grep score | cut -d, -f2 | cut -d: -f2`
	GAMEOVER_CNT=`grep "YOUR_RESULT" ${TMP_LOG} -2 | grep score | cut -d, -f3 | cut -d: -f2`
	_1LINE_CNT=`grep "SCORE DETAIL" ${TMP_LOG} -5 | grep "1 line" | cut -d= -f2`
	_2LINE_CNT=`grep "SCORE DETAIL" ${TMP_LOG} -5 | grep "2 line" | cut -d= -f2`
	_3LINE_CNT=`grep "SCORE DETAIL" ${TMP_LOG} -5 | grep "3 line" | cut -d= -f2`
	_4LINE_CNT=`grep "SCORE DETAIL" ${TMP_LOG} -5 | grep "4 line" | cut -d= -f2`
	RESULT_STR="${REPOSITORY_OWNER}, ${LEVEL}, ${SCORE}, ${LINE_CNT}, ${GAMEOVER_CNT}, ${_1LINE_CNT}, ${_2LINE_CNT}, ${_3LINE_CNT}, ${_4LINE_CNT}"
	echo ${RESULT_STR}
	echo ${RESULT_STR} >> ${RESULT_LOG}
	popd

        # wait game finish
	GAME_TIME=10
	sleep $GAME_TIME	
    done

    cat ${RESULT_LOG}

    return 0
}

do_game

#for ((i=0; i<${LOOP_TIMES}; i++));
#do
#    #check_latest_hash
#    do_game ${i} 1 225 # 180 * 5/4 
#    do_game ${i} 2 225 # 180 * 5/4 
#    do_game ${i} 3 225 # 180 * 5/4
#done

