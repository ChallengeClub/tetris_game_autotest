#!/bin/bash

# pyenv
# pyenv virtualenv 3.9.1 myenv
# pyenv virtualenv 3.7.7 myenv3.7.7
# pyenv virtualenv 3.6.9 myenv3.6.9

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



