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

def get_option(user_name, program_name, level, branch_name, mode, weight, max_time, external_game_time, logfilejson, score_list_file):
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
    argparser.add_argument('-b', '--branch_name', type=str,
                           default=branch_name,
                           help='branch_name')
    argparser.add_argument('-m', '--mode', type=str,
                           default=mode,
                           help='mode')
    argparser.add_argument('-w', '--weight', type=str,
                           default=weight,
                           help='weight')    
    argparser.add_argument('-t', '--max_time', type=int,
                           default=max_time,
                           help='max_time')
    argparser.add_argument('-e', '--external_game_time', type=int,
                           default=external_game_time,
                           help='external_game_time')
    argparser.add_argument('-f', '--logfilejson', type=str,
                           default=logfilejson,
                           help='log file (.json) name')
    argparser.add_argument('-s', '--score_list_file', type=str,
                           default=score_list_file,
                           help='score output file (.txt) name')
    argparser.add_argument('--use_elapsed_time', type=str,
                           default="False",
                           help='use elapsed time(True/False)')        
    return argparser.parse_args()

def res_cmd(cmd):
    return subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True).communicate()[0]

def get_line_score(logfile):
    LOGFILE=logfile

    if os.path.exists(LOGFILE) == False:
        return 0, 0, 0, 0, 0, 0, 0, 0

    cmd1 = ("jq .debug_info.line_score_stat[0] " + LOGFILE)
    cmd2 = ("jq .debug_info.line_score_stat[1] " + LOGFILE)
    cmd3 = ("jq .debug_info.line_score_stat[2] " + LOGFILE)
    cmd4 = ("jq .debug_info.line_score_stat[3] " + LOGFILE)
    cmd5 = ("jq .judge_info.score " + LOGFILE)
    GAMEOVER_COUNT_CMD = ("jq .judge_info.gameover_count " + LOGFILE)

    cmd6 = ("jq .debug_info.line_score.\"line1\" " + LOGFILE)
    cmd7 = ("jq .debug_info.line_score.\"line2\" " + LOGFILE)
    cmd8 = ("jq .debug_info.line_score.\"line3\" " + LOGFILE)
    cmd9 = ("jq .debug_info.line_score.\"line4\" " + LOGFILE)
    GAMEOVER_SCORE_CMD = ("jq .debug_info.line_score.gameover " + LOGFILE)
    BLOCK_INDEX_CMD= ("jq .judge_info.block_index " + LOGFILE)
    ELAPSED_TIME_CMD= ("jq .judge_info.elapsed_time " + LOGFILE)    
    
    res1 = res_cmd(cmd1)
    res2 = res_cmd(cmd2)
    res3 = res_cmd(cmd3)
    res4 = res_cmd(cmd4)
    res5 = res_cmd(cmd5)
    
    res6 = res_cmd(cmd6)
    res7 = res_cmd(cmd7)
    res8 = res_cmd(cmd8)
    res9 = res_cmd(cmd9)

    GAMEOVER_COUNT_CMD_RES = res_cmd(GAMEOVER_COUNT_CMD)
    GAMEOVER_SCORE_CMD_RES = res_cmd(GAMEOVER_SCORE_CMD)
    BLOCK_INDEX_CMD_RES = res_cmd(BLOCK_INDEX_CMD)
    ELAPSED_TIME_CMD_RES = res_cmd(ELAPSED_TIME_CMD)
    try:
        _1line_score = int(res1)*int(res6)#*100
        _2line_score = int(res2)*int(res7)#*300
        _3line_score = int(res3)*int(res8)#*700
        _4line_score = int(res4)*int(res9)#*1200
        _total_score = int(res5)
        _gameover_score = int(GAMEOVER_COUNT_CMD_RES)*int(GAMEOVER_SCORE_CMD_RES)#*1200
        block_index = int(BLOCK_INDEX_CMD_RES)
        elapsed_time = float(ELAPSED_TIME_CMD_RES)
    except:
        return -1, -1, -1, -1, -1, -1, -1, -1

    return _1line_score, _2line_score, _3line_score, _4line_score,_total_score, _gameover_score, block_index, elapsed_time

class Window(QMainWindow): 

    def __init__(self): 
        super().__init__() 

        # show information
        self.user_name = "testuser"
        self.program_name = "---"
        self.level = 1
        self.branch_name = "---"
        self.mode = "---"
        self.weight = "---"
        self.max_time = 180
        self.external_game_time = 0
        self.total_score = 0
        self.lap_score = 0
        self.lap_count = 0
        self.lap_interval_sec = 60
        self.max_timer_count = self.max_time * 10
        self.external_game_time_count = self.external_game_time * 10
        self.logfilejson = "/home/ubuntu/xxx"
        self.score_list_file = "---"
        self.current_txt = ""
        self.use_elapsed_time = False

        args = get_option(self.user_name,
                          self.program_name,
                          self.level,
                          self.branch_name,
                          self.mode,
                          self.weight,
                          self.max_time,
                          self.external_game_time,
                          self.logfilejson,
                          self.score_list_file)

        if len(args.user_name) != 0:
            self.user_name = args.user_name
        if len(args.program_name) != 0:
            self.program_name = args.program_name
        if args.level >= 0:
            self.level = args.level
        if len(args.branch_name) != 0:
            self.branch_name = args.branch_name
        if len(args.mode) != 0:
            self.mode = args.mode
        if len(args.weight) != 0:
            self.weight = args.weight
            # get last value by split "/"
            self.weight = self.weight.split("/")[-1]
        if args.max_time >= 0:
            self.max_timer_count = args.max_time * 10
        if args.external_game_time >= 0:
            self.external_game_time_count = args.external_game_time * 10
        if len(args.logfilejson) != 0:
            self.logfilejson = args.logfilejson
            print("logfile: " + args.logfilejson)
        if args.score_list_file != "---":
            self.score_list_file = args.score_list_file
        if args.use_elapsed_time == "True":
            self.use_elapsed_time = True
            
        # setting title
        windowtitle="Player_information"
        if len(args.user_name) != 0:
            windowtitle="Score_" + self.user_name
        self.setWindowTitle(windowtitle)

        # setting geometry
        upper_left = (100,100)
        #width_height = (280, 380)
        width_height = (100+180, 470)
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
        label_width_height = (270, 460)
        self.label.setGeometry(label_upper_left[0], label_upper_left[1], 
                               label_width_height[0], label_width_height[1]) 
        self.label.setStyleSheet("border : 4px solid black;") 
        self.label.setText(self.gettimertext())
        self.label.setFont(QFont('Arial', 18))
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

        if self.timer_count > (self.max_timer_count + self.external_game_time_count):
            # exit app
            sys.exit(App.exec())

        # showing text 
        self.label.setText(self.gettimertext())

    def gettimertext(self):

        _1line_score, _2line_score, _3line_score , _4line_score, _total_score, _gameover_score, block_index, elapsed_time = get_line_score(self.logfilejson)
        if _1line_score < 0:
            # if get line score returns error..
            # for example, .
            return self.current_txt

        # get timer_value from elapsed time in json
        time_str = str('{:.01f}'.format(self.timer_count/10))
        if self.use_elapsed_time == True:
            time_str = str('{:.01f}'.format(elapsed_time + 0.5))

        # get lap_score(ex. 0/3,1/3,2/3,)
        self.total_score = _total_score
        if float(time_str) >= self.lap_interval_sec * (self.lap_count+1):
            self.lap_count += 1
            self.lap_score = self.total_score
        
        self.current_text = "Player: " + self.user_name + "\n" \
        + self.branch_name + "\n" \
        + self.program_name + "\n" \
        + "Mode: " + self.mode + "\n" \
        + self.weight + "\n" \
        + "TIME: " + time_str + "/" + str(int(self.max_timer_count/10)) + " (s)" + "\n" \
        + "BLOCK: " + str(block_index) + "\n" \
        + "LEVEL: " + str(self.level) + "\n" \
        + "SCORE: " + str(_total_score) + "\n" \
        + "  1line: " + str(_1line_score) + "\n" \
        + "  2line: " + str(_2line_score) + "\n" \
        + "  3line: " + str(_3line_score) + "\n" \
        + "  4line: " + str(_4line_score) + "\n" \
        + "  gameover: " + str(_gameover_score) + "\n" \
        + "  lap_score(" + str(self.lap_count) + "/" + str(self.max_time//self.lap_interval_sec) + "): " + str(self.lap_score)

        if self.score_list_file != "---":
            # save score_list_file to prepare to display score list.
            if int(float(time_str)) >= self.timer_prev + 1:
                self.timer_prev = int(float(time_str))
                try:
                    # try to open current file
                    with open(self.score_list_file, 'rb') as f:
                        score_list = pickle.load(f)
                except:
                    # if no file, create new file
                    score_list = []
                finally:
                    score_list.append( _total_score )
                    with open(self.score_list_file, 'wb') as f:
                        pickle.dump(score_list, f)
                
        return self.current_text

# create pyqt5 app 
App = QApplication(sys.argv) 

# create the instance of our Window 
window = Window() 

# start the app 
sys.exit(App.exec())
