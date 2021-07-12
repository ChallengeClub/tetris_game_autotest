from PyQt5.QtWidgets import * 
from PyQt5 import QtCore, QtGui 
from PyQt5.QtGui import * 
from PyQt5.QtCore import * 
import sys 
from argparse import ArgumentParser

def get_option(player_name, level):
    argparser = ArgumentParser()
    argparser.add_argument('--player_name', type=str,
                           default=player_name,
                           help='player name')
    argparser.add_argument('--level', type=int,
                           default=level,
                           help='level')
    return argparser.parse_args()

class Window(QMainWindow): 

    def __init__(self): 
        super().__init__() 

        # setting title 
        self.setWindowTitle("Player information") 

        # show information
        self.player_name = "testuser"
        self.level = 1
        self.max_timer_count = 1800 # seconds = max_timer_count * 0.1[s]

        args = get_option(self.player_name,
                          self.level)
        if len(args.player_name) != 0:
            self.player_name = args.player_name
        if args.level >= 0:
            self.level = args.level

        # setting geometry
        upper_left = (100,100)
        width_height = (480, 200)
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
        label_width_height = (440, 160)
        self.label.setGeometry(label_upper_left[0], label_upper_left[1], 
                               label_width_height[0], label_width_height[1]) 
        self.label.setStyleSheet("border : 4px solid black;") 
        self.label.setText(self.gettimertext())
        self.label.setFont(QFont('Arial', 40))
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
        text = "Player: " + self.player_name + "\n" \
        + "LEVEL: " + str(self.level) + "\n" \
        + "TIME: " + str('{:.01f}'.format(self.timer_count / 10)) + " (s)"
        return text

# create pyqt5 app 
App = QApplication(sys.argv) 

# create the instance of our Window 
window = Window() 

# start the app 
sys.exit(App.exec())
