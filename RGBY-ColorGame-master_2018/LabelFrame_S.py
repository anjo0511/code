# -*- coding: utf-8 -*-
#Written by Andreé Johnsson <bio13ajn@cs.umu.se> and Hampus Silverlind <bio15hsd@cs.umu.se>
#Course Application Programming in Python, 7.5 Credits at Umea University.
#Usage requires permission by the author.
#
from tkinter import *

class LabelFrame_S:    
    def __init__(self,root):
        ''' 
            Syfte: Makes a frame with labels and buttons.
            ReturvÃ¤rde: -
            Kommentarer: -
        '''
        self.root = root
        self.scoreFrame = Frame(self.root,bd=2,relief='solid',height=100,width=600,pady=20,padx=200)
        self.scoreFrame["bg"] = "bisque3"
        self.topLabels()
        self.navegationButtons()


    def navegationButtons(self):
        ''' 
            Syfte: default layout of buttons
            ReturvÃ¤rde: -
            Kommentarer: -
        '''        
        self.navBotton = Button(self.scoreFrame,text='Start', padx=5,pady=5,activebackground= "papaya whip",bg="bisque3",relief=RAISED,bd=4)
        self.navBotton2 = Button(self.scoreFrame,text='Reset', padx=5,pady=5,activebackground= "papaya whip",bg="bisque3",relief=RAISED,bd=4)
        self.navBotton3 = Button(self.scoreFrame,text='Highscores', padx=5,pady=5,activebackground= "papaya whip",bg="bisque3",relief=RAISED,bd=4)
        self.navBotton4 = Button(self.scoreFrame,text='Back',padx=5,pady=5,activebackground= "papaya whip",bg="bisque3",relief=RAISED,bd=4)
                
        self.navBotton.pack()
        self.navBotton2.pack(side=LEFT)
        self.navBotton3.pack(side=LEFT)
        self.navBotton4.pack(side=LEFT)


    def setLinktoNavButtons(self,function):
        ''' 
            Syfte: binds the buttons to a function
            ReturvÃ¤rde: -
            Kommentarer: -
        '''
        self.function = function
        self.navBotton.bind('<ButtonRelease-1>', self.function)
        self.navBotton2.bind('<ButtonRelease-1>', self.function)
        self.navBotton3.bind('<ButtonRelease-1>', self.function)
        self.navBotton4.bind('<ButtonRelease-1>', self.function)
                

    def topLabels(self):
        ''' 
            Syfte: The label is created with level and lives 0 but just once.
            ReturvÃ¤rde: -
            Kommentarer: -
        '''
        self.levelLable = StringVar()
        level_Label = Label(self.scoreFrame,textvariable=self.levelLable, font= 'Times 18',pady=5)
        level_Label.pack()

        self.livesLable= StringVar()
        lives_Label = Label(self.scoreFrame,textvariable=self.livesLable,font= 'Times 18',pady=15)    
        lives_Label.pack()

        level_Label["bg"] = "bisque3"
        lives_Label["bg"] = "bisque3"
        self.chageLabelFrame(0,0)
   

    def chageLabelFrame(self,level,lives):
        ''' 
            Syfte: changes the top label to match the current level and lives
            ReturvÃ¤rde: -
            Kommentarer: -
        '''
        self.levelLable.set('Level: '+str(level))
        self.livesLable.set('Lives: '+str(lives))


    def showFrame(self, bol=None):
        ''' 
            Syfte: Shows hides Frame
            ReturvÃ¤rde: 
            Kommentarer: 
        '''
        if bol is True:
            self.scoreFrame.pack()
        elif bol is False:
            self.scoreFrame.pack_forget()  
     
