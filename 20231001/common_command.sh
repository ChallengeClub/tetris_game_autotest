#!/bin/bash -x

function GET_COMMAND(){

    LEVEL=${1}
    DROP_SPEED=${2}
    GAME_TIME=${3}
    RANDOM_SEED=${4}
    UNAME=${5}
    LOGFILE=${6}
    TETRIS_DIR=${7}
    MODE=${8}           # -m "${MODE}" --predict_weight "${PREDICT_WEIGHT}"
    PREDICT_WEIGHT=${9} # -m "${MODE}" --predict_weight "${PREDICT_WEIGHT}"
    
    if [ "${UNAME}" == "seigot" ]; then
	# ex)機械学習用のファイルをダウンロードして、game_managerの下におく
	ADD_COMMAND="ls"
	EXEC_COMMAND="${ADD_COMMAND} && python3 start.py -l ${LEVEL} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m ${MODE} --predict_weight ${PREDICT_WEIGHT}"

    elif [ "${UNAME}" == "bushio" ]; then
	# bushioさん用のtetris
	ADD_COMMAND="curl -LJO https://raw.githubusercontent.com/seigot/tools/master/tetris/20220901_cuda_unavailable.patch &&\
	patch -p1 < 20220901_cuda_unavailable.patch"
	EXEC_COMMAND="${ADD_COMMAND} && python3 start.py -l ${LEVEL} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m ${MODE} --predict_weight ${PREDICT_WEIGHT}"

    elif [ "${UNAME}" == "neonblue3___" -a "${LEVEL}" != "2" ]; then
	# neonblue3さん用のtetris
	ADD_COMMAND="curl -LJO https://raw.githubusercontent.com/seigot/tools/master/tetris/20231001_aoki.patch  &&\
	patch -p1 < 20231001_aoki.patch"
	EXEC_COMMAND="${ADD_COMMAND} && python3 start.py -l ${LEVEL} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m ${MODE} --predict_weight ${PREDICT_WEIGHT}"	
	
    elif [ "${UNAME}" == "Kurikuri33" ]; then
	# neonblue3さん用のtetris
	ADD_COMMAND="curl -LJO https://raw.githubusercontent.com/Kurikuri33/tetris_score_server/main/block_controller_sample.py &&\
	cp block_controller_sample.py game_manager/."
	EXEC_COMMAND="${ADD_COMMAND} && python3 start.py -l ${LEVEL} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m ${MODE} --predict_weight ${PREDICT_WEIGHT}"	
    else
	# other
	PREDICT_WEIGHT_OPTION="--predict_weight ${PREDICT_WEIGHT}"
	if [ "${PREDICT_WEIGHT}" == "default" ]; then
	    PREDICT_WEIGHT_OPTION=""
	fi
	#-d ${DROP_SPEED}
	EXEC_COMMAND="python3 start.py -l ${LEVEL} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m ${MODE} ${PREDICT_WEIGHT_OPTION}"
    fi
    echo ${EXEC_COMMAND}
}


function GET_COMMAND_ART(){

    LEVEL=${1}
    DROP_SPEED=${2}
    GAME_TIME=${3}
    RANDOM_SEED=${4}
    UNAME=${5}
    LOGFILE=${6}
    TETRIS_DIR=${7}
    MODE=${8}
    ART_CONFIG_FILEPATH=${9}
    BLOCK_NUM_MAX=${10}
    # other
    # -d ${DROP_SPEED}
    EXEC_COMMAND="python3 start.py -l ${LEVEL} -t ${GAME_TIME} -d ${DROP_SPEED} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m ${MODE} --art_config_filepath ${ART_CONFIG_FILEPATH} --BlockNumMax ${BLOCK_NUM_MAX}"
    echo ${EXEC_COMMAND}
}


