#!/bin/bash -x

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

# init RESULT_LOG
echo "repository_name, level, score, line, gameover, 1line, 2line, 3line, 4line" > $RESULT_LOG

# enable pyenv (if necessary)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# function
function do_game(){

    LEVEL=$1

    if [ ${LEVEL} == 1 ]; then
	# level 1
	CLONE_REPOSITORY_LIST=(
	    "http://github.com/kyad/tetris_game -b forever-branch"
	    "http://github.com/yuin0/tetris_game -b feature/yuin0/improve-controller2"
	    "http://github.com/hirov2/tetris_game"
	)
    elif [ ${LEVEL} == 2 ]; then
	CLONE_REPOSITORY_LIST=(
	    "http://github.com/sue-robo/tetris_game -b dev3"
	)
    else
	echo "invalid level ${LEVEL}"
	return
    fi

    cd ~

    # main loop
    for (( i = 0; i < ${#CLONE_REPOSITORY_LIST[@]}; i++ ))
    do
	#############
	##
	##  prepare
	##
	#############
	REPOSITORY_OWNER=`echo ${CLONE_REPOSITORY_LIST[$i]} | cut -d' ' -f1 | cut -d'/' -f4`
	#SOUND_NUMBER=`echo $((RANDOM%+3))` # 0-2 random value
	SOUND_NUMBER=`echo $[i]`
	SOUND_NUMBER=`echo $(( $[SOUND_NUMBER] % ${#CLONE_REPOSITORY_LIST[@]} ))`
	SOUNDFILE_NAME=${SOUNDFILE_LIST[$SOUND_NUMBER]}
	GAMETIME=180

	if [ ${REPOSITORY_OWNER} == "kyad" ];then
	    LEVEL=777
	fi

	# pyenv select
	if [ ${LEVEL} == 1 -o ${LEVEL} == 777 ]; then
	    # other env (python3.6.9)
	    pyenv activate myenv3.6.9
	    python -V
	else
	    # sue-robo_env
	    pyenv activate sue-robo_env
	fi
	
	echo "git clone ${CLONE_REPOSITORY_LIST[$i]}"
	echo "REPOSITORY_OWNER: ${REPOSITORY_OWNER}"
	echo "LEVEL: ${LEVEL}"
	echo "SOUND_NUMBER: ${SOUND_NUMBER}"
	echo "SOUNDFILE_NAME: ${SOUNDFILE_NAME}"

	#############
	##
	##  main
	##
	#############
	rm -rf tetris_game
	mkdir tetris_game
	git clone ${CLONE_REPOSITORY_LIST[$i]}
	pushd tetris_game
	play ${SOUNDFILE_NAME} &
	python3 ${DISPLAY_PY} --player_name ${REPOSITORY_OWNER} --level ${LEVEL} &
	bash start.sh -l${LEVEL} > ${TMP_LOG} -t ${GAMETIME}
	sleep 2

	#############
	##
	##  finish
	##
	#############
	# pyenv deactivate
	pyenv deactivate

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

do_game 1
do_game 2


echo "ALL GAME FINISH !!!"
exit 0


"http://github.com/kyad/tetris_game"
"http://github.com/yuin0/tetris_game"
"http://github.com/adelie7273/tetris_game"
"http://github.com/anchobi-no/tetris_game"
"http://github.com/dadada-dada/tetris_game"
"http://github.com/F0CACC1A/tetris_game"
"http://github.com/Git0214/tetris_game"
"http://github.com/hirov2/tetris_game"
"http://github.com/iceball360/tetris_game"
"http://github.com/isshy-you/tetris_game"
"http://github.com/k-onishi/tetris_game"
"http://github.com/Leozyc-waseda/tetris_game"
"http://github.com/n-nooobu/tetris_game"
"http://github.com/neteru141/tetris_game"
"http://github.com/nmurata90/tetris_game"
"http://github.com/nogumasa/tetris_game"
"http://github.com/OhdachiEriko/tetris_game"
"http://github.com/sahitaka/tetris_game"
"http://github.com/sue-robo/tetris_game"
"http://github.com/taichofu/tetris_game"
"http://github.com/tara938/tetris_game"
"http://github.com/tommy-m18/tetris_game"
"http://github.com/tsumekko/tetris_game"
"http://github.com/YSK-2/tetris_game"

