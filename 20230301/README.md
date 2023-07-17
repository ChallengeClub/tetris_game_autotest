## about

repository for tetris score_attack/tournament.

https://github.com/seigot/tetris

### environment

for ubuntu20.04 or upper version

### prepare

(recommend) install python3.10 venv  
https://qiita.com/murakami77/items/b612734ff209cbb22afb

```
sudo apt update -y
sudo apt install python3-venv
```

set venv

```
# set venv (only first time)
mkdir -p ~/venv
python3 -m venv ~/venv/python3.10-test
cd ~
ln -s venv/python3.10-test venvtest

# activate
source ~/venv/python3.10-test/bin/activate
```

pip install library

```
# for basic functions
pip install pyqt5
pip install numpy
# for machine learning
#pip -r requirements.pytorch.txt
wget https://raw.githubusercontent.com/seigot/tetris/master/requirements.pytorch.txt
pip install -r requirements.pytorch.txt

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

# demo_art
bash demo_art.sh
```

for test sub-programs

```
python image.py -u hoge -i imagename.img  # display User image
python score.py -u hoge -p testname       # display User score
python display_graph.py                   # display score graph
bash stop.sh                              # stop programs
```
