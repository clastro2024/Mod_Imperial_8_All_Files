import sys, os
from PySide6.QtCore import *
from PySide6.QtWidgets import *
from PySide6.QtGui import *


windowWidth = 1024
windowHeight = 768
bgImagePath = r"D:/Sohan Sain/Games/Praetorians/New Mod/Util Programs/bgImage.png"




class NewWindow(QMainWindow):
    def __init__(self, windowTitle, QSize, background):
        super().__init__()

        self.setWindowTitle(windowTitle)
        self.setFixedSize(QSize)
        if ("/" in background) | ("//" in background):
            self.setStyleSheet(f"background: url('{background}'); background-repeat: no-repeat")
        else:
            self.setStyleSheet(f"background: {background}")        

            

    def createText(self, text, color='white', fontSize=25, QRect=QRect(60, 60, 400, 40)):
        textLabel = QLabel(self)
        textLabel.setGeometry(QRect)
        textLabel.setStyleSheet(f"background: transparent; color: {color}; font: {fontSize}px;")
        textLabel.setText(text)

        return textLabel
    


    def createButton(self, text, color, fontSize, QRect, background='transparent', onClick=None):
        button = QPushButton(text, self)
        button.setGeometry(QRect)
        button.setText(text)
        if ("." in background):
            button.setStyleSheet(f"background-image: url('{background}'); background-repeat: no-repeat;  color: {color}; font-size: {fontSize}px;")
        else:
            button.setStyleSheet(f"background: {background};  color: {color}; font: {fontSize}px;")
        
        if onClick:
            button.clicked.connect(onClick)
        # padding: 0px; margin: 0px; border: 3px solid blue; outline: none;


        
        



app = QApplication(sys.argv)

# mainWindow = NewWindow()

settingsWindow = NewWindow("Praetorians Mod Caesar Settings", QSize(windowWidth, windowHeight), bgImagePath)


settingsWindow.createText("- Set In-Game Background -----")
settingsWindow.createButton("Set BG", 'white', 25, QRect(70, 110, 300, 40), 'D:/Sohan Sain/Games/Praetorians/New Mod/Util Programs/buttonGradient.jpg')


settingsWindow.show()


app.exec()


# path = r'./Praetorians'
# os.chdir(path)
# os.system("Praetorians.exe")