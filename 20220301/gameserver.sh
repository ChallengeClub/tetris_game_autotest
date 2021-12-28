#!/bin/bash

# prepare
#   - install docker
#   - prepare to push to github

function update_result(){
    # update to github??    
    # https://github.com/seigot/tetris_score_server

    STR=${1}
    
    #git clone https://github.com/seigot/tetris_score_server
    #pushd tetris_score_server
    #echo $STR > test.log
    #git add test.log
    #git commit -m "test update"
    #git push
    #popd
}

function error_result(){

    # error
    DATETIME=`date +%Y%m%d_%H%M_%S`
    REPOSITORY_URL="$1"
    SCORE="$2"
    LEVEL="$3"
    #echo "|  ${DATETIME}  |  ${REPOSITORY_URL}  |  ${SCORE}  |  ${LEVEL}  |  FAIL  |"
}

function success_result(){

    DATETIME=`date +%Y%m%d_%H%M_%S`
    REPOSITORY_URL="$1"
    SCORE="$2"
    LEVEL="$3"

    echo "|  ${DATETIME}  |  ${REPOSITORY_URL}  |  ${SCORE}  |  ${LEVEL}  |  SUCCESS  |"

    update_result "|  ${DATETIME}  |  ${REPOSITORY_URL}  |  ${SCORE}  |  ${LEVEL}  |  SUCCESS  |"

}

function do_tetris(){

    REPOSITORY_URL="$1"
    LEVEL="1"
    PRE_COMMAND="cd ~ && rm -rf tetris && git clone ${REPOSITORY_URL} && cd ~/tetris && pip3 install -r requirements.txt"
    DO_COMMAND="cd ~/tetris && python3 start.py -l ${LEVEL} -t 3 && jq . result.json"
    POST_COMMAND="cd ~/tetris && jq .judge_info.score result.json"

    TMP_LOG="tmp.log"
    CONTAINER_NAME="tetris_docker"

    # run docker with detached state
    RET=`docker ps -a | grep ${CONTAINER_NAME} | wc -l`
    if [ $RET -ne 0 ]; then
	docker stop ${CONTAINER_NAME}
	docker rm ${CONTAINER_NAME}
    fi
    docker run -d --name ${CONTAINER_NAME} -p 6080:80 -e DISPLAY=$DISPLAY --shm-size=512m seigott/tetris_docker

    # exec command
    docker exec ${CONTAINER_NAME} bash -c "sudo apt-get install -y xvfb"
    docker exec ${CONTAINER_NAME} bash -c "${PRE_COMMAND}"
    docker exec ${CONTAINER_NAME} bash -c "${DO_COMMAND}"
    docker exec ${CONTAINER_NAME} bash -c "${POST_COMMAND}" > ${TMP_LOG}    

    # get result score
    SCORE=`cat ${TMP_LOG} | tail -1`
    echo $SCORE
    success_result ${REPOSITORY_URL} ${SCORE} ${LEVEL}
}

function do_polling(){

    ### polling ###
    # if google spread sheet will be updated
    # https://docs.google.com/forms/d/1UePTIx-ujAFulC5bRgf7OMI3u0IzzxxK2_z4NZRb1Ac/edit

    ### error check ###
    # DELETE unnecessary strings
    # URL_CHECK: "https://github.com/seigot/tetris"
    # BLANK_CHECK:
    # CLONE tetris CHECK:

    # do tetris
    do_tetris "https://github.com/seigot/tetris"
}

do_polling
