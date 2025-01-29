from .windowClass import NewWindow
from ..config import settingsWindowWidth, settingsWindowHeight, bgImagePath
from PySide6.QtCore import *
from PySide6.QtWidgets import *
from PySide6.QtGui import *
import sys


class SettingsWindow(QMainWindow):
    def __init__(self):
        app = QApplication(sys.argv)
        settingsWindow = NewWindow("Mod Settings", QSize(settingsWindowWidth, settingsWindowHeight), bgImagePath)


        settingsWindow.createText("- Set In-Game Background -----")
        settingsWindow.createButton("Set BG", 'white', 25, QRect(70, 110, 300, 40), 'D:/Sohan Sain/Games/Praetorians/New Mod/Util Programs/buttonGradient.jpg')

        settingsWindow.createText("- Set In-Game Background -----")
        settingsWindow.createButton("Set BG", 'white', 25, QRect(70, 110, 300, 40), 'D:/Sohan Sain/Games/Praetorians/New Mod/Util Programs/buttonGradient.jpg')

        settingsWindow.show()
        app.exec()



SettingsWindow()