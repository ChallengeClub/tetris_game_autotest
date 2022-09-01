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
#	ADD_COMMAND="curl -LJO https://raw.githubusercontent.com/seigot/tools/master/tetris/ai_tmp/game_manager/machine_learning/block_controller_train_sample.py &&\
#	mv block_controller_train_sample.py game_manager/machine_learning/. &&\
#	curl -LJO https://raw.githubusercontent.com/seigot/tools/master/tetris/ai_tmp/game_manager/machine_learning/deep_q_network.py &&\
#	mv deep_q_network.py game_manager/machine_learning/. &&\
#	mkdir trained_models &&\
#	curl -LJO https://github.com/seigot/tools/raw/master/tetris/ai_tmp/trained_models/tetris &&\
#	cp tetris trained_models/."
#	EXEC_COMMAND="${ADD_COMMAND} && python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m predict_sample"
#	ADD_COMMAND="ls"
	ADD_COMMAND="curl -LJO https://raw.githubusercontent.com/seigot/tools/master/tetris/20220901_cuda_unavailable.patch &&\
	patch -p1 < 20220901_cuda_unavailable.patch"
	EXEC_COMMAND="${ADD_COMMAND} && python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m ${MODE} --predict_weight ${PREDICT_WEIGHT}"

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

    elif [ "${UNAME}" == "cookie4869" -o "${UNAME}" == "qbi-sui" -o "${UNAME}" == "krymt28" ]; then

	# cuda patch
	PATCH_NAME="20220901_cuda_unavailable_${UNAME}.patch"
	ADD_COMMAND="curl -LJO https://raw.githubusercontent.com/seigot/tools/master/tetris/${PATCH_NAME} &&\
	patch -p1 < ${PATCH_NAME}"
	EXEC_COMMAND="${ADD_COMMAND} && python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m ${MODE} --predict_weight ${PREDICT_WEIGHT}"

    elif [ "${UNAME}" == "tuyosi1227" ]; then
	# cuda patch
	#PATCH_NAME="20220901_cuda_unavailable_${UNAME}.patch"
	ADD_COMMAND="ls -l"
	EXEC_COMMAND="${ADD_COMMAND} && python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m ${MODE} --predict_weight ${PREDICT_WEIGHT}"

    elif [ "${UNAME}" == "bushio" ]; then
	# bushioさん用のtetris
	ADD_COMMAND="curl -LJO https://raw.githubusercontent.com/seigot/tools/master/tetris/20220901_cuda_unavailable.patch &&\
	patch -p1 < 20220901_cuda_unavailable.patch"
	EXEC_COMMAND="${ADD_COMMAND} && python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m ${MODE} --predict_weight ${PREDICT_WEIGHT}"

    elif [ "${UNAME}" == "mattshamrock" -o "${UNAME}" == "usamin24" -o  "${UNAME}" == "isshy-you" -o "${UNAME}" == "yuin0" -o "${UNAME}" == "4321623" -o "${UNAME}" == "kyad" ]; then
	ADD_COMMAND="ls"
	EXEC_COMMAND="${ADD_COMMAND} && python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE}"
    else
	# other
	EXEC_COMMAND="python3 start.py -l ${LEVEL} -d ${DROP_SPEED} -t ${GAME_TIME} -r ${RANDOM_SEED} -u ${UNAME} -f ${LOGFILE} -m ${MODE} --predict_weight ${PREDICT_WEIGHT}"
    fi
    echo ${EXEC_COMMAND}
}


