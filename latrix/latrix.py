
import os,sys,time

from PyQt5.QtCore import *
from PyQt5.QtNetwork import *
from PyQt5.QtWidgets import *


from ui_mainwindow import *


class MainWindow(QMainWindow):
    def __init__(self, parent = None):
        super(MainWindow, self).__init__(parent)
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)
        
        return
    

def main():
    app = QApplication(sys.argv)
    import qtutil
    qtutil.pyctrl()

    mw = MainWindow()
    mw.show()

    app.exec_()
    return


if __name__ == '__main__': main()
