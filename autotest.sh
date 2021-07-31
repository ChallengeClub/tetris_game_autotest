#!/bin/bash -x

# execute requirement
# 1. install,and prepare pyenv,pyvirtualenv
# 2. put sound(.WAV) file on ~/Downloads/.
# 3. put image(.jpg) file on ~/Downloads/.
#

CURRENT_DIR=`pwd`
TMP_LOG="${CURRENT_DIR}/tmp.log"
DISPLAY_PY="${CURRENT_DIR}/display.py"
RESULT_LOG="${CURRENT_DIR}/result.log"
DISPLAY_LOG="${CURRENT_DIR}/display.log"

# ffmpeg -i *.mp4 -ac 1 *.wav
# ffmpeg -i *.mp3 *.wav
SOUNDFILE_LIST=(
    "~/Downloads/technotris.wav"
    "~/Downloads/troika.wav"
    "~/Downloads/kalinka.wav"
)

# init RESULT_LOG
echo "repository_name, program_name, level, score, line, gameover, 1line, 2line, 3line, 4line, RET_GREP_RANDINT_1_8" > $RESULT_LOG

# enable pyenv (if necessary)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# function
function do_game(){

    LEVEL=$1

    # get repository list
    if [ ${LEVEL} == 1 ]; then
	# level 1
	CLONE_REPOSITORY_LIST=(
	    "ぴよぴよテトリス!https://github.com/tara938/tetris_game -b v1.0"
	    "tetris01!http://github.com/YSK-2/tetris_game -b tetris01"
	    "たまごくらぶK!http://github.com/iceball360/tetris_game -b 1.0"
	    "トム・クルーズ!http://github.com/Git0214/tetris_game"
	    "超超超たまごくらぶ いきものがかり!http://github.com/tsumekko/tetris_game -b master"
	    "Cracked Egg!http://github.com/yuin0/tetris_game -b v1.0"
	    "Genelic Algorithm Murata!http://github.com/nmurata90/tetris_game -b master"
	    "テトリスマン Level1!http://github.com/n-nooobu/tetris_game -b v1.0"	    
	    "いっしーの２人め４号!http://github.com/isshy-you/tetris_game -b 1.4e"
	    "奇跡のバランス３号くん!http://github.com/hirov2/tetris_game -b FirstStrategy_003"
	    "必要なのは根気だけ１号!http://github.com/hirov2/tetris_game -b SCENARIO_01"
	    "とことん高得点狙い!http://github.com/OhdachiEriko/tetris_game -b master"
	)
    elif [ ${LEVEL} == 2 ]; then
	# level 2
	CLONE_REPOSITORY_LIST=(
	    "いっしーの２人め４号!http://github.com/isshy-you/tetris_game -b 1.4e"
	    "いっしーの２人め５号!http://github.com/isshy-you/tetris_game -b 1.4e" # 4号との違いはstart.sh
	    "必要なのは根気だけ１号!http://github.com/hirov2/tetris_game -b SCENARIO_01"
	    "奇跡のバランス３号くん!http://github.com/hirov2/tetris_game -b FirstStrategy_003"
	    "チームたいちとだいち２号!http://github.com/sahitaka/tetris_game -b v1.0"
	    "Cracked Egg!http://github.com/yuin0/tetris_game -b v1.0"
	    "テトリスマン Level2!http://github.com/n-nooobu/tetris_game -b v1.0"
	    "sue-robo!http://github.com/sue-robo/tetris_game -b submit"
	    #"チームたいちとだいち３号!http://github.com/taichofu/tetris_v2 -b v1"
	    #"チームたいちとだいち４号!http://github.com/neteru141/tetris_game -b v1.1.0"
	    ###"xxx!http://github.com/sue-robo/tetris_game -b dev3"
	)
    elif [ ${LEVEL} == 3 ]; then
	# level 3
	CLONE_REPOSITORY_LIST=(
	    "必要なのは根気だけ１号!http://github.com/hirov2/tetris_game -b SCENARIO_01"
	    "奇跡のバランス３号くん!http://github.com/hirov2/tetris_game -b FirstStrategy_003"
	    "いっしーの２人め５号!http://github.com/isshy-you/tetris_game -b 1.4e" # 4号との違いはstart.sh
	    "Cracked Egg!http://github.com/yuin0/tetris_game -b v1.0"
	)
    elif [ ${LEVEL} == 777 ]; then
	# forever branch
	CLONE_REPOSITORY_LIST=(
	    "無限テトリス!http://github.com/kyad/tetris_game -b forever-branch"
	)
    else
	echo "invalid level ${LEVEL}"
	return
    fi

    # main loop
    for (( i = 0; i < ${#CLONE_REPOSITORY_LIST[@]}; i++ ))
    do
	#############
	##
	##  prepare
	##
	#############
	REPOSITORY_OWNER=`echo ${CLONE_REPOSITORY_LIST[$i]} | cut -d! -f2- | cut -d' ' -f1 | cut -d'/' -f4`
	CLONE_REPOSITORY=`echo ${CLONE_REPOSITORY_LIST[$i]} | cut -d! -f2-`
	PROGRAM_NAME=`echo ${CLONE_REPOSITORY_LIST[$i]} | cut -d! -f1`
	#SOUND_NUMBER=`echo $((RANDOM%+3))` # 0-2 random value
	SOUND_NUMBER=`echo $[i]`
	SOUND_NUMBER=`echo $(( $[SOUND_NUMBER] % ${#SOUNDFILE_LIST[@]} ))`
	SOUNDFILE_PATH=${SOUNDFILE_LIST[$SOUND_NUMBER]}
	SOUNDFILE_NAME=`echo ${SOUNDFILE_PATH} | cut -d/ -f3`
	IMAGE_NUMBER=`echo $((RANDOM%+6))` # 0-2 random value	
	IMAGE_NAME="megen${IMAGE_NUMBER}.jpg"
	RAMDOM_SEED="202108041234567890"
	GAMETIME=180
	START_SH="start.sh"

	# pyenv select
	if [ ${LEVEL} == 1 -o ${LEVEL} == 777 ]; then
	    # other env (python3.6.9)
	    pyenv activate myenv3.6.9
	    python -V
	elif [ ${REPOSITORY_OWNER} == "sue-robo" ]; then
	    # sue-robo_env
	    pyenv activate sue-robo_env
	else
	    # default
	    pyenv activate myenv3.6.9
	    python -V
	fi
	
	echo "git clone ${CLONE_REPOSITORY}"
	echo "PROGRAM_NAME: ${PROGRAM_NAME}"
	echo "REPOSITORY_OWNER: ${REPOSITORY_OWNER}"
	echo "LEVEL: ${LEVEL}"
	echo "SOUND_NUMBER: ${SOUND_NUMBER}"
	echo "SOUNDFILE_PATH: ${SOUNDFILE_PATH}"

	#############
	##
	##  main
	##
	#############
	cd ~
	rm -rf tetris_game
	mkdir tetris_game
	git clone ${CLONE_REPOSITORY}
	pushd tetris_game

	# fix game time
	sed -e "s/elapsed_time > self.game_time/elapsed_time > self.game_time - 0.5/g" game_manager/game_manager.py > game_manager/game_manager.py.org
	mv game_manager/game_manager.py.org game_manager/game_manager.py

	# each repository pre-setting
	if [ ${REPOSITORY_OWNER} == "isshy-you" -a ${PROGRAM_NAME} == "いっしーの２人め４号" ]; then
	    echo "START_SH=start_04d.sh"
	    START_SH="start_04d.sh"
	elif [ ${REPOSITORY_OWNER} == "isshy-you" -a ${PROGRAM_NAME} == "いっしーの２人め５号" ]; then
	    echo "START_SH=start_04e.sh"
	    START_SH="start_04e.sh"
	elif [ ${REPOSITORY_OWNER} == "sahitaka" -a ${PROGRAM_NAME} == "チームたいちとだいち２号" ]; then
	    echo "START_SH=start.sh"
	    START_SH="start.sh -s y"
	elif [ ${REPOSITORY_OWNER} == "tara938" -a ${PROGRAM_NAME} == "ぴよぴよテトリス" ]; then
	    # copy special files...
	    cp -rp ${CURRENT_DIR}/tara938/* .
	#elif [ ${REPOSITORY_OWNER} == "YSK-2" ]; then
	#    #cp block_controller2.py block_controller.py
	#    sed -e "s/BLOCK_CONTROLLER_SAMPLE/BLOCK_CONTROLLER/g" block_controller2.py > block_controller.py
	else
	    echo "no each repository setting"
	fi

	# random seed preparation
	if [ ${LEVEL} == 2 -o ${LEVEL} == 3 ]; then
	    echo "fix random seed ${RAMDOM_SEED}"
	    TARGET_LINE=`grep --line-number "game_manager.py" ${START_SH} | tail -1 | cut -d: -f1`
	    sed -e "${TARGET_LINE}i RANDOM_SEED=\"${RAMDOM_SEED}\"" ${START_SH} > start.sh.org
	    mv start.sh.org ${START_SH}

	    # update randint range
	    if [ ${PROGRAM_NAME} == "必要なのは根気だけ１号" -o ${PROGRAM_NAME} == "奇跡のバランス３号くん" ]; then
		echo "update randint range!!"
		sed -e "s/random.randint(1, 7)/random.randint(1, 8)/g" game_manager/board_manager.py > game_manager/board_manager.py.org
		mv game_manager/board_manager.py.org game_manager/board_manager.py
	    fi
	fi
	
        ###### wait game -->
	WAIT_TIME=30
	#sleep ${WAIT_TIME}
	eog ~/Downloads/${IMAGE_NAME} &
	sleep 1
	WINDOWID=`xdotool search --onlyvisible --name "${IMAGE_NAME}"`
	xdotool windowmove ${WINDOWID} 600 100
	echo -n >| ${DISPLAY_LOG} # create empty file
	python3 ${DISPLAY_PY} --player_name "Next... ${REPOSITORY_OWNER}" --program_name "${PROGRAM_NAME}" --level ${LEVEL} --sound_name "xxx" --max_time ${WAIT_TIME}
	pkill "eog"
	###### wait game <--
	
	###### do game	
	# start
	play ${SOUNDFILE_PATH} &
	eog ~/Downloads/${IMAGE_NAME} &
	python3 ${DISPLAY_PY} --player_name ${REPOSITORY_OWNER} --program_name "${PROGRAM_NAME}" --level ${LEVEL} --sound_name ${SOUNDFILE_NAME} --max_time ${GAMETIME} &
	
	bash ${START_SH} -l${LEVEL} -t${GAMETIME} > ${TMP_LOG} &
	# move window
	sleep 1
	WINDOWID=`xdotool search --onlyvisible --name "Tetris" | tail -1`
	xdotool windowmove ${WINDOWID} 600 100
	WINDOWID=`xdotool search --onlyvisible --name "${IMAGE_NAME}"`
	xdotool windowmove ${WINDOWID} 900 100
	# wait finish
	sleep ${GAMETIME}
	pkill "eog"
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
	# check if update randint() to fix bug...
	grep -r "np_randomShape.random.randint(1, 8)" *
	RET_GREP_RANDINT_1_8=$?
	RESULT_STR="${REPOSITORY_OWNER}, ${PROGRAM_NAME}, ${LEVEL}, ${SCORE}, ${LINE_CNT}, ${GAMEOVER_CNT}, ${_1LINE_CNT}, ${_2LINE_CNT}, ${_3LINE_CNT}, ${_4LINE_CNT}, ${RET_GREP_RANDINT_1_8}"

	echo ${RESULT_STR}
	echo ${RESULT_STR} >> ${RESULT_LOG}
	echo ${RESULT_STR} > ${DISPLAY_LOG}

        ###### wait game -->
	WAIT_TIME=30
	#sleep $GAME_TIME
	python3 ${DISPLAY_PY} --player_name "Done... ${REPOSITORY_OWNER}" --program_name "${PROGRAM_NAME}" --level ${LEVEL} --sound_name "xxx" --max_time ${WAIT_TIME}	
        ###### wait game <--

	popd

    done

    cat ${RESULT_LOG}

    return 0
}

function do_capture(){

    MODE=$1
    
    if [ $MODE == "start" ];then
	# capture start
	#	gnome-terminal -- recordmydesktop --no-cursor --fps 5 --width 1366 --height 768
	gnome-terminal -- recordmydesktop --no-cursor
    elif [ $MODE == "stop" ];then
	PROCESS_ID=`ps -e -o pid,cmd | grep "recordmydesktop" | grep -v grep | awk '{print $1}'`
	kill $PROCESS_ID
	# wait to kill process
	LOOP_TIMES=3600
	for i in `seq ${LOOP_TIMES}`
	do
	    NUM=`ps -e -o pid,cmd | grep "recordmydesktop" | grep -v grep | wc -l`
	    if [ $NUM -eq 0 ]; then
		break;
	    fi
	    sleep 1
	done
    fi
}

#do_capture "start"
#do_game 777 # forever branch
do_game 1   # level1
do_game 2   # level2
do_game 3   # level3
#do_capture "stop"

#for i in `seq 10`
#do
#    do_game 1   # level1
#done
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

