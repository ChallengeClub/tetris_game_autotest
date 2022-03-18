#!/bin/bash -x

function GET_COMMAND(){

    LEVEL=${1}
    DROP_SPEED=${2}
    GAME_TIME=${3}
    RANDOM_SEED=${4}
    UNAME=${5}
    LOGFILE=${6}
    TETRIS_DIR=${7}

    if [ "${UNAME}" == "seigot" ]; then
	# 機械学習用のファイルをダウンロードして、game_managerの下におく
	ADD_COMMAND="curl -LJO https://raw.githubusercontent.com/seigot/tools/master/tetris/ai_tmp/game_manager/machine_learning/block_controller_train_sample.py &&\
	mv block_controller_train_sample.py game_manager/machine_learning/. &&\
	curl -LJO https://raw.githubusercontent.com/seigot/tools/master/tetris/ai_tmp/game_manager/machine_learning/deep_q_network.py &&\
	mv deep_q_network.py game_manager/machine_learning/. &&\
	mkdir trained_models &&\
	curl -LJO https://github.com/seigot/tools/raw/master/tetris/ai_tmp/trained_models/tetris &&\
	cp tetris trained_models/."
	EXEC_COMMAND="${ADD_COMMAND} && python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m predict_sample"
	
    elif [ "${UNAME}" == "neteru141" ]; then
	# neteru141さん用のtetris
	ADD_COMMAND="curl -LJO https://raw.githubusercontent.com/seigot/tools/master/tetris/ai_tmp/game_manager/machine_learning/block_controller_train_sample.py &&\
	mv block_controller_train_sample.py game_manager/machine_learning/. &&\
	curl -LJO https://raw.githubusercontent.com/seigot/tools/master/tetris/ai_tmp/game_manager/machine_learning/deep_q_network.py &&\
	mv deep_q_network.py game_manager/machine_learning/. &&\
	mkdir trained_models &&\
	curl -LJO https://github.com/neteru141/tetris_game/blob/submit/trained_models/tetris?raw=true &&\
	mv tetris\?raw\=true trained_models/tetris &&\
	ln -s machine_learning/deep_q_network.py game_manager/deep_q_network.py"

	EXEC_COMMAND="${ADD_COMMAND} && python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m predict_sample"

    elif [ "${UNAME}" == "bushio" ]; then
	# bushioさん用のtetris
	ADD_COMMAND="curl -LJO https://raw.githubusercontent.com/seigot/tools/master/tetris/20220315_disable_cuda.patch &&\
	patch -p1 < 20220315_disable_cuda.patch"
	EXEC_COMMAND="${ADD_COMMAND} && python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m predict"

    elif [ "${UNAME}" == "EndoNrak" ]; then
	# neteru141さん用のtetris
	ADD_COMMAND="curl -LJO https://raw.githubusercontent.com/seigot/tools/master/tetris/20220318_endo.patch &&\
	patch -p1 < 20220318_endo.patch"
	
	EXEC_COMMAND="${ADD_COMMAND} && python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m predict"

    else
	EXEC_COMMAND="python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE}"
    fi

    echo ${EXEC_COMMAND}
}


