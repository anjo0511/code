# -*- coding: utf-8 -*-
#Written by Andreé Johnsson <bio13ajn@cs.umu.se> and Hampus Silverlind <bio15hsd@cs.umu.se>
#Course Application Programming in Python, 7.5 Credits at Umea University.
#Usage requires permission by the author.
#
from tkinter import *

class HighScoreFrame():
    def __init__(self,root):
        ''' 
            Syfte: Makes a highscore frame to print the Higscore sheet
            ReturvÃ¤rde: -
            Kommentarer: -
        ''' 
        self.root = root
        self.highscoreFrameLayout()
        self.highScoreFrame["bg"] = "papaya whip"
        self.theonlyLabel["bg"] = "papaya whip"


    def highscoreFrameLayout(self):
        ''' 
            Syfte: basic layout of higscore frame
            ReturvÃ¤rde: -
            Kommentarer: -
        '''           
        self.highScoreFrame = Frame(self.root, bd=4, relief='solid', padx=50)   
        self.highScore_var = StringVar()   
        self.theonlyLabel=Label(self.highScoreFrame,textvariable=self.highScore_var,bd=1,font='Times 11 bold',padx=10,pady=5)     
        self.theonlyLabel.pack()


    def changeHighscoreFrame(self,textstring):
        ''' 
            Syfte: changes the label given a string
            ReturvÃ¤rde: -
            Kommentarer: -
        '''         
        self.highScore_var.set(textstring)


    def showFrame(self, bol=None):
        ''' 
            Syfte: Shows hides frame
            ReturvÃ¤rde: -
            Kommentarer: -
        '''         
        if bol is True:
            self.highScoreFrame.pack()
        elif bol is False:
            self.highScoreFrame.pack_forget() 

