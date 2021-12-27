#!/usr/bin/python3
# -*- coding: utf-8 -*-

from PyQt5.QtWidgets import * 
from PyQt5 import QtCore, QtGui 
from PyQt5.QtGui import * 
from PyQt5.QtCore import * 
import sys 
from argparse import ArgumentParser
import subprocess

def get_option(user_name, program_name, level, max_time):
    argparser = ArgumentParser()
    argparser.add_argument('-u', '--user_name', type=str,
                           default=user_name,
                           help='player name')
    argparser.add_argument('-p', '--program_name', type=str,
                           default=program_name,
                           help='program name')    
    argparser.add_argument('-l', '--level', type=int,
                           default=level,
                           help='level')
    argparser.add_argument('-t', '--max_time', type=int,
                           default=max_time,
                           help='max_time')
    return argparser.parse_args()

def res_cmd(cmd):
    return subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True).communicate()[0]

def get_line_score():
    LOGFILE="/home/ubuntu/tetris/result.json"
    cmd1 = ("jq .debug_info.line_score_stat[0] " + LOGFILE)
    cmd2 = ("jq .debug_info.line_score_stat[1] " + LOGFILE)
    cmd3 = ("jq .debug_info.line_score_stat[2] " + LOGFILE)
    cmd4 = ("jq .debug_info.line_score_stat[3] " + LOGFILE)
    cmd5 = ("jq .judge_info.score /home/ubuntu/tetris/result.json")

    cmd6 = ("jq .debug_info.line_score.\"line1\" " + LOGFILE)
    cmd7 = ("jq .debug_info.line_score.\"line2\" " + LOGFILE)
    cmd8 = ("jq .debug_info.line_score.\"line3\" " + LOGFILE)
    cmd9 = ("jq .debug_info.line_score.\"line4\" " + LOGFILE)
    
    res1 = res_cmd(cmd1)
    res2 = res_cmd(cmd2)
    res3 = res_cmd(cmd3)
    res4 = res_cmd(cmd4)
    res5 = res_cmd(cmd5)
    
    res6 = res_cmd(cmd6)
    res7 = res_cmd(cmd7)
    res8 = res_cmd(cmd8)
    res9 = res_cmd(cmd9)
    
    try:
        _1line_score = int(res1)*int(res6)#*100
        _2line_score = int(res2)*int(res7)#*300
        _3line_score = int(res3)*int(res8)#*700
        _4line_score = int(res4)*int(res9)#*1200
        _total_score = int(res5)
    except:
        return -1, -1, -1, -1, -1

    return _1line_score, _2line_score, _3line_score, _4line_score,_total_score

class Window(QMainWindow): 

    def __init__(self): 
        super().__init__() 

        # show information
        self.user_name = "testuser"
        self.program_name = "---"
        self.level = 1
        self.max_time = 180
        self.max_timer_count = self.max_time * 10
        self.current_txt = ""
        
        args = get_option(self.user_name,
                          self.program_name,
                          self.level,
                          self.max_time)
        if len(args.user_name) != 0:
            self.user_name = args.user_name
        if len(args.program_name) != 0:
            self.program_name = args.program_name
        if args.level >= 0:
            self.level = args.level
        if args.max_time >= 0:
            self.max_timer_count = args.max_time * 10

        # setting title
        windowtitle="Player_" + self.user_name + "_information"
        self.setWindowTitle(windowtitle)

        # setting geometry
        upper_left = (100,100)
        width_height = (280, 380)
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
        self.timer_flag = True
        # LAP parameter
        self.lap_count = 0
        self.lap_count_max = 3

        # creating a label to show the time 
        self.label = QLabel(self)
        label_upper_left = (5, 5)
        label_width_height = (270, 370)
        self.label.setGeometry(label_upper_left[0], label_upper_left[1], 
                               label_width_height[0], label_width_height[1]) 
        self.label.setStyleSheet("border : 4px solid black;") 
        self.label.setText(self.gettimertext())
        self.label.setFont(QFont('Arial', 22))
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

        _1line_score, _2line_score, _3line_score , _4line_score, _total_score = get_line_score()
        if _1line_score < 0:
            return self.current_txt
        
        self.current_text = "Player: " + self.user_name + "\n" \
        + self.program_name + "\n" \
        + "LEVEL: " + str(self.level) + "\n" \
        + "SCORE: " + str(_total_score) + "\n" \
        + "  1line: " + str(_1line_score) + "\n" \
        + "  2line: " + str(_2line_score) + "\n" \
        + "  3line: " + str(_3line_score) + "\n" \
        + "  4line: " + str(_4line_score)
        #+ "TIME: " + str('{:.01f}'.format(self.timer_count / 10)) + "/" + str(self.max_timer_count/10) + " (s)" + "\n" \

        return self.current_text

# create pyqt5 app 
App = QApplication(sys.argv) 

# create the instance of our Window 
window = Window() 

# start the app 
sys.exit(App.exec())
