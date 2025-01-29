from PySide6.QtCore import *
from PySide6.QtWidgets import *
from PySide6.QtGui import *


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

