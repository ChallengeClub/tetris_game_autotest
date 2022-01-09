#!/bin/bash

# ubuntu18.04でpyenv,virtualenvをインストールする
# https://qiita.com/seigot/items/de7b2d4f3bb68c704cab

# pyenv
# pyenv virtualenv 3.9.1 myenv
# pyenv virtualenv 3.7.7 myenv3.7.7
# pyenv virtualenv 3.6.9 myenv3.6.9

function install_myenv3_6_9() {
    pip3 install --upgrade pip
    python3 -m pip install PyQt5
    pip3 install numpy
}

function install_sue-robo_env() {
    # sue-robo_env
    pip3 install --upgrade pip
    python3 -m pip install PyQt5
    pip3 install numpy
    pip3 install torch torchvision torchaudio -f https://download.pytorch.org/whl/lts/1.8/torch_lts.html
    pip3 install --upgrade tensorflow
    pip3 install tqdm
    # if you have exec error
    #   ModuleNotFoundError: No module named '_ctypes'
    #
    # fix as follows
    #   sudo apt-get install libffi-dev 
    #   pyenv install 3.9.1
    # https://qiita.com/seigot/items/d4528fc584e4b58b070e
}

function install_taichofu_env() {
    # taichofu env
    # git clone http://github.com/taichofu/tetris_v2
    # base: docker v1.4
    pip3 install --upgrade pip
    python3 -m pip install PyQt5
    pip3 install numpy

    #pip3 install torch==1.4.0 torchvision==0.2.2
    pip3 install pillow
    #pip3 install scikit-learn
    #pip3 install -U pandas
    pip3 install opencv-python==3.4.10.37
    pip3 install matplotlib
    pip3 install torch torchvision torchaudio -f https://download.pytorch.org/whl/lts/1.8/torch_lts.html

    # because of error
    #   https://qiita.com/seigot/items/f379854eb595b932b9e4
    pip3 uninstall -y opencv-python
    pip3 install opencv-python-headless
}

function install_neteru141_env() {
    # neteru141 env
    # git clone http://github.com/neteru141/tetris_game -b v1.1.0
    # base: docker v1.4
    #echo "base: docker v1.4"

    ###### same with taichofu_env ###### 
}

function install_neteru141_2_env() {
    # neteru141 env
    # git clone http://github.com/neteru141/tetris_game -b v1.1.0
    # base: docker v1.4
    #echo "base: docker v1.4"

    pip3 --version
    ## python 3.9.9
    pip3 install pyqt5
    pip3 install numpy
    pip3 install pillow
    pip3 install matplotlib
    pip3 install torch torchvision torchaudio -f https://download.pytorch.org/whl/lts/1.8/torch_lts.html
    pip3 install tensorboardX

    ## prediction
    git clone http://github.com/neteru141/tetris_game -b v1.1.0
    cd tetris_game
    bash start.sh -l2

    ## train
    git clone http://github.com/neteru141/tetris_game -b dev4
    cd tetris_game
    bash start.sh -l2
    ### その後、しばらく２０分くらい放置しておく
    ### train/tetris が学習モデル

    ## 以下のようにするとtrainしたモデルが動く
    git clone http://github.com/neteru141/tetris_game -b submit
    cd tetris_game
    bash start.sh -l2

    ###### same with taichofu_env ###### 
}

source ~/.bashrc

pyenv activate myenv
python -V
pyenv deactivate

pyenv activate myenv3.6.9
python -V
pyenv deactivate

pyenv activate myenv3.7.7
python -V
pyenv deactivate

pyenv activate sue-robo_env
bash start.sh -t 100
pyenv deactivate



