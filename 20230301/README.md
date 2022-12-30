## about

repository for tetris score_attack/tournament.

https://github.com/seigot/tetris

### environment

for ubuntu18.04 or upper version

### prepare

set venv

```
# set venv (only first time)
python3 -m venv ~/venvtest

# activate
source ~/venvtest/bin/activate
```

install library

```
# for basic functions
pip install pyqt5
pip install numpy
# for machine learning
pip -r requirements.txt

# for score_attack
pip install opencv-python
# for display graph
pip install matplotlib
```

install tools

```
sudo apt install xdotool -y  # gui command
sudo apt install sox -y      # sound command
sudo apt install imagemagick -y # graphics command
sudo apt install python-is-python3 -y
sudo apt install python3.8-venv -y
sudo apt install python3-pyqt5 
```

download data

```
wget https://github.com/seigot/tetris_game_autotest/releases/download/20220901/Downloads.tgz
tar zxvf Downloads.tgz
```

### programs

execute programs for score attack, tournament

```
# score attack
bash score_attack.sh

# tournament
bash tournament.sh
```

for test sub-programs

```
python image.py -u hoge -i imagename.img  # display User image
python score.py -u hoge -p testname       # display User score
python display_graph.py                   # display score graph
bash stop.sh                              # stop programs
```
