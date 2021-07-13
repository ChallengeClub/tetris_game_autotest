#!/bin/bash

# pyenv
# pyenv virtualenv 3.9.1 myenv
# pyenv virtualenv 3.7.7 myenv3.7.7
# pyenv virtualenv 3.6.9 myenv3.6.9

function test_install() {
    # sue-robo
    pip3 install --upgrade pip
    python3 -m pip install PyQt5
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



