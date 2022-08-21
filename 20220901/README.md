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
# for machine learning
pip -r requirements.txt

# for score_attack
pip install opencv-python
```

### programs

execute programs for score attack, tournaments

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
python score_attack.py                    # run tetris for score attack
python tournament.py                      # run tetris for tournament
python display_graph.py                      # run tetris for tournament
```
