from PyQt5.QtWidgets import * 
from PyQt5 import QtCore, QtGui 
from PyQt5.QtGui import * 
from PyQt5.QtCore import * 
import sys 
from argparse import ArgumentParser
import subprocess

def get_option(player_name, level, sound_name, max_time):
    argparser = ArgumentParser()
    argparser.add_argument('--player_name', type=str,
                           default=player_name,
                           help='player name')
    argparser.add_argument('--level', type=int,
                           default=level,
                           help='level')
    argparser.add_argument('--sound_name', type=str,
                           default=sound_name,
                           help='sound_name')
    argparser.add_argument('--max_time', type=int,
                           default=max_time,
                           help='max_time')
    return argparser.parse_args()

def res_cmd(cmd):
  return subprocess.Popen(
      cmd, stdout=subprocess.PIPE,
      shell=True).communicate()[0]

def get_line_score():
  #cmd = ("ls -l")
  #cmd0 = ("ls -l") #("touch tmp.log")
  cmd1 = ("tail -n500 /home/ubuntu/tetris_game_autotest/tmp.log | grep line_score_stat | tail -1 | cut -d: -f2 | cut -d[ -f2 | cut -d] -f1 | cut -d, -f1")
  cmd2 = ("tail -n500 /home/ubuntu/tetris_game_autotest/tmp.log | grep line_score_stat | tail -1 | cut -d: -f2 | cut -d[ -f2 | cut -d] -f1 | cut -d, -f2")
  cmd3 = ("tail -n500 /home/ubuntu/tetris_game_autotest/tmp.log | grep line_score_stat | tail -1 | cut -d: -f2 | cut -d[ -f2 | cut -d] -f1 | cut -d, -f3")
  cmd4 = ("tail -n500 /home/ubuntu/tetris_game_autotest/tmp.log | grep line_score_stat | tail -1 | cut -d: -f2 | cut -d[ -f2 | cut -d] -f1 | cut -d, -f4")
  cmd5 = ("tail -n500 /home/ubuntu/tetris_game_autotest/tmp.log | grep -e 'score' | grep -v 'dropdownscore' | grep -v 'line_score' | grep -v 'linescore' | tail -1 | cut -d: -f2 | cut -d} -f1")

  #res0 = res_cmd(cmd0)
  res1 = res_cmd(cmd1)
  res2 = res_cmd(cmd2)
  res3 = res_cmd(cmd3)
  res4 = res_cmd(cmd4)
  res5 = res_cmd(cmd5)
  #res5 = 0

  #print(res0)
  #print(res_cmd(cmd1))
  #print(int(res1))
  #print(int(res2))
  #print(int(res3))
  #print(int(res4))
  #print(int(res5))

  #if res0 is b'':
  #    print ("none")
  #    res0 = 0
  #if res1 == b'':
  #    print ("none")
  #    res1 = 0      
  #if res2 == b'':
  #    print ("none")
  #    res2 = 0      
  #if res3 == b'':
  #    print ("none")
  #    res3 = 0
  #if res4 == b'':
  #    print ("none")
  #    res4 = 0
  #if res5 == b'':
  #    print ("none")
  #    res5 = 0

  try:
      _1line_score = int(res1)*100
      _2line_score = int(res2)*300
      _3line_score = int(res3)*700
      _4line_score = int(res4)*1200
      _total_score = int(res5)
  except:
      print('Error')
      return 0, 0, 0, 0, 0

  return _1line_score, _2line_score, _3line_score, _4line_score,_total_score

class Window(QMainWindow): 

    def __init__(self): 
        super().__init__() 

        # setting title 
        self.setWindowTitle("Player information") 

        # show information
        self.player_name = "testuser"
        self.level = 1
        self.sound_name = "xxx"
        self.max_time = 180
        self.max_timer_count = self.max_time * 10

        args = get_option(self.player_name,
                          self.level,
                          self.sound_name,
                          self.max_time)
        if len(args.player_name) != 0:
            self.player_name = args.player_name
        if args.level >= 0:
            self.level = args.level
        if len(args.sound_name) != 0:
            self.sound_name = args.sound_name
        if args.max_time >= 0:
            self.max_timer_count = args.max_time * 10

        # setting geometry
        upper_left = (100,100)
        width_height = (480, 480)
        self.setGeometry(upper_left[0], upper_left[1],
                         width_height[0], width_height[1]) 

        # calling method 
        self.UiComponents() 

        # showing all the widgets 
        self.show() 

    # method for widgets 
    def UiComponents(self): 

        # timer parameter
        self.timer_count = 0.0
        self.timer_flag = True #False
        # LAP parameter
        self.lap_count = 0
        self.lap_count_max = 3

        # creating a label to show the time 
        self.label = QLabel(self)
        label_upper_left = (20, 20)
        label_width_height = (440, 440)
        self.label.setGeometry(label_upper_left[0], label_upper_left[1], 
                               label_width_height[0], label_width_height[1]) 
        self.label.setStyleSheet("border : 4px solid black;") 
        self.label.setText(self.gettimertext())
        self.label.setFont(QFont('Arial', 30))
        self.label.setAlignment(Qt.AlignCenter) 

        # creating a timer object 
        timer = QTimer(self) 
        timer.timeout.connect(self.callback_showTime)
        timer.start(100) # update the timer by n(msec)

    # timer callback function 
    def callback_showTime(self):
        # update timer_conut
        if self.timer_flag == True:
            self.timer_count+= 1

        if self.timer_count > self.max_timer_count:
            # exit app
            sys.exit(App.exec())

        # showing text 
        self.label.setText(self.gettimertext())

    def gettimertext(self):

        #_1line_score, _2line_score, _3line_score , _4line_score, _total_score = get_line_score()
        _1line_score = 0
        _2line_score = 0
        _3line_score = 0
        _4line_score = 0
        _total_score = 0
        
        text = "Player: " + self.player_name + "\n" \
        + "LEVEL: " + str(self.level) + "\n" \
        + "TIME: " + str('{:.01f}'.format(self.timer_count / 10)) + "/" + str(self.max_timer_count/10) + " (s)" + "\n" \
        + "SOUND: " + self.sound_name + "\n" \
        + "SCORE: " + str(_total_score) + "\n" \
        + "  1line: " + str(_1line_score) + "\n" \
        + "  2line: " + str(_2line_score) + "\n" \
        + "  3line: " + str(_3line_score) + "\n" \
        + "  4line: " + str(_4line_score)
                          
        return text

# create pyqt5 app 
App = QApplication(sys.argv) 

# create the instance of our Window 
window = Window() 

# start the app 
sys.exit(App.exec())
