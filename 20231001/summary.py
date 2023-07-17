#!/usr/bin/python3
# -*- coding: utf-8 -*-

from PyQt5.QtWidgets import * 
from PyQt5 import QtCore, QtGui 
from PyQt5.QtGui import * 
from PyQt5.QtCore import * 
import sys 
from argparse import ArgumentParser
import subprocess
import os
import pickle

def res_cmd(cmd):
    return subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True).communicate()[0]

def get_line_score():

    cmd1 = ("cat ./result/win_count_kokko1023.log")
    cmd2 = ("cat ./result/win_count_km-mssh.log")
    cmd3 = ("cat ./result/win_count_cookie4869.log")
    cmd4 = ("cat ./result/win_count_Takomaron.log")
    res1 = res_cmd(cmd1)
    res2 = res_cmd(cmd2)
    res3 = res_cmd(cmd3)
    res4 = res_cmd(cmd4)
    try:
        _user1_count = int(res1)
        _user2_count = int(res2)
        _user3_count = int(res3)
        _user4_count = int(res4)
    except:
        return -1, -1, -1, -1
    return _user1_count, _user2_count, _user3_count, _user4_count

class Window(QMainWindow): 

    def __init__(self): 
        super().__init__() 

        windowtitle="summary"
        self.setWindowTitle(windowtitle)

        # setting geometry
        upper_left = (100,100)
        width_height = (100+450, 150)
        self.setGeometry(upper_left[0], upper_left[1],
                         width_height[0], width_height[1]) 

        # calling method 
        self.UiComponents() 

        # showing all the widgets 
        self.show() 

    # method for widgets 
    def UiComponents(self): 

        # timer parameter
        self.timer_count_init = 40.0
        self.timer_count = self.timer_count_init
        self.timer_prev = -1
        self.timer_flag = True
        # LAP parameter
        self.lap_count = 0
        self.lap_count_max = 3

        # creating a label to show the time 
        self.label = QLabel(self)
        label_upper_left = (5, 5)
        label_width_height = (540, 130)
        self.label.setGeometry(label_upper_left[0], label_upper_left[1], 
                               label_width_height[0], label_width_height[1]) 
        self.label.setStyleSheet("border : 4px solid black;") 
        self.label.setText(self.gettimertext())
        self.label.setFont(QFont('Arial', 24))
        self.label.setAlignment(Qt.AlignCenter) 

        # creating a timer object 
        timer = QTimer(self) 
        timer.timeout.connect(self.callback_showTime)
        timer.start(100) # update the timer by n(msec)

    # timer callback function 
    def callback_showTime(self):
        # showing text 
        self.label.setText(self.gettimertext())

    def gettimertext(self):

        _count1, _count2, _count3 , _count4 = get_line_score()

        self.current_text = "win_count: \n" \
        + "kokko1023: "  + str(_count1) + ", " \
        + "km-mssh: "    + str(_count2) + "\n" \
        + "cookie4869: " + str(_count3) + ", " \
        + "Takomaron: "  + str(_count4)

        return self.current_text

# create pyqt5 app 
App = QApplication(sys.argv) 

# create the instance of our Window 
window = Window() 

# start the app 
sys.exit(App.exec())
