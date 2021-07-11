#!/bin/bash -x

#cd $HOME/catkin_ws/src/burger_war_kit
#CATKIN_WS_DIR=$HOME/catkin_ws
#BURGER_WAR_KIT_REPOSITORY=$HOME/catkin_ws/src/burger_war_kit
#BURGER_WAR_DEV_REPOSITORY=$HOME/catkin_ws/src/burger_war_dev
#BURGER_WAR_AUTOTEST_LOG_REPOSITORY=$HOME/catkin_ws/src/burger_war_autotest
#RESULTLOG=$BURGER_WAR_KIT_REPOSITORY/autotest/result.log
#SRC_LOG=$RESULTLOG
#TODAY=`date +"%Y%m%d"`
#DST_LOG=$BURGER_WAR_AUTOTEST_LOG_REPOSITORY/result/result-${TODAY}.log
#LATEST_GITLOG_HASH="xxxx"

echo "repository_name, level, score" > $RESULTLOG

# get option
#LOOP_TIMES=10
#IS_CAPTURE_VIDEO="false"
#while getopts l:c: OPT
#do
#  case $OPT in
#    "l" ) LOOP_TIMES="$OPTARG" ;;
#    "c" ) IS_CAPTURE_VIDEO="$OPTARG" ;;
#  esac
#done
## echo option parameter
#echo "LOOP_TIMES: ${LOOP_TIMES}"
#echo "IS_CAPTURE_VIDEO: ${IS_CAPTURE_VIDEO}"
#
#
#pushd ${BURGER_WAR_KIT_REPOSITORY}
#source autotest/slack.sh
#popd

CURRENT_DIR=`pwd`
TMP_LOG="${CURRENT_DIR}/tmp.log"
RESULT_LOG="${CURRENT_DIR}/result.log"

SOUNDFILE_LIST=(
    "~/Downloads/technotris.mp3"
    "~/Downloads/troika.mp3"
    "~/Downloads/kalinka.mp3"
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
	RAND_NUMBER=`echo $((RANDOM%+3))` # 0-2 random value
	SOUNDFILE_NAME=${SOUNDFILE_LIST[$RAND_NUMBER]}

	if [ ${REPOSITORY_OWNER} == "kyad" ];then
	    LEVEL=777
	fi
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
	bash start.sh -l${LEVEL} > ${TMP_LOG}
	SCORE=`grep "YOUR_RESULT" ${TMP_LOG} -2 | grep score | cut -d, -f1 | cut -d: -f2`
	echo "${REPOSITORY_OWNER}, ${LEVEL}, ${SCORE}" >> ${RESULT_LOG}
	popd

        # wait game finish
	GAME_TIME=10
	sleep $GAME_TIME	
    done

    cat ${RESULT_LOG}
}

do_game

#for ((i=0; i<${LOOP_TIMES}; i++));
#do
#    #check_latest_hash
#    do_game ${i} 1 225 # 180 * 5/4 
#    do_game ${i} 2 225 # 180 * 5/4 
#    do_game ${i} 3 225 # 180 * 5/4
#done

