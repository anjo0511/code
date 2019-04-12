# -*- coding: utf-8 -*-
#Written by Andreé Johnsson <bio13ajn@cs.umu.se> and Hampus Silverlind <bio15hsd@cs.umu.se>
#Course Application Programming in Python, 7.5 Credits at Umea University.
#Usage requires permission by the author.
#
from tkinter import *

class Countdown():
    def __init__(self, root, buttonFrame, tmpLevelSeq):
        ''' 
            Syfte: Makes a frame that packs in the images
                and then updates the score lables via the 
                countdownimage swap method.
            ReturvÃ¤rde: -
            Kommentarer: -
        '''         
        self.tmpLevelSeq = tmpLevelSeq
        self.buttonFrame = buttonFrame
        self.countlabel = Label()
        self.countlabel.pack()
        self.timer3 = PhotoImage(file="3timer.png")
        self.timer2 = PhotoImage(file="2timer.png")
        self.timer1 = PhotoImage(file="1timer.png")
        self.countdownImageSwap(4)


    def countdownImageSwap(self, counter = False):
        ''' 
            Syfte: Changes the image recursively until the last image where
            the button simulation gets triggered.
            ReturvÃ¤rde: -
            Kommentarer: -
        ''' 
        if counter:
            self.t = counter
        if self.t == 4:
            self.countlabel.configure(image=self.timer3)          
        if self.t == 3:
            self.countlabel.configure(image=self.timer2)  
        if self.t == 2:
            self.countlabel.configure(image=self.timer1)
        if self.t == 1:
            self.countlabel.pack_forget()
        if self.t == 0:            
            self.buttonFrame.simulation(self.tmpLevelSeq)
        else:
            self.t = self.t - 1
            self.countlabel.after(1000, self.countdownImageSwap)

