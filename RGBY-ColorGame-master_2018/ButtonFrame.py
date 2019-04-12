# -*- coding: utf-8 -*-
#Written by Andreé Johnsson <bio13ajn@cs.umu.se> and Hampus Silverlind <bio15hsd@cs.umu.se>
#Course Application Programming in Python, 7.5 Credits at Umea University.
#Usage requires permission by the author.
#
from tkinter import *
from tkinter import messagebox
import time

class ButtonFrame:
    def __init__(self, root):
        ''' 
            Syfte: Creates a frame with colour buttons inside 
            ReturvÃ¤rde: -
            Kommentarer: -
        '''
        self.root = root
        self.buttonFrame = Frame(self.root,bd=2,relief='solid',height=150,width=200)
        self.colourButtonLayout()


    def colourButtonLayout(self):
        ''' 
            Syfte: The base layout of the buttons i.e the apperience and position.
            ReturvÃ¤rde: -
            Kommentarer: -
        '''
        self.button_R = Button(self.buttonFrame, text='R', bg='red',
                          height=4, width=8, bd=7, relief='raised')
        self.button_G = Button(self.buttonFrame, text='G', bg='green',
                          height=4, width=8, bd=7, relief='raised')
        self.button_B = Button(self.buttonFrame, text='B', bg='blue',
                          height=4, width=8, bd=7, relief='raised')
        self.button_Y = Button(self.buttonFrame, text='Y', bg='yellow',
                          height=4, width=8, bd=7, relief='raised')

        self.button_R.grid(row=0, column=0)
        self.button_G.grid(row=0, column=1)
        self.button_B.grid(row=1, column=0)
        self.button_Y.grid(row=1, column=1)

        self.button_R['activebackground'] = self.button_R.cget('background')
        self.button_G['activebackground'] = self.button_G.cget('background')
        self.button_B['activebackground'] = self.button_B.cget('background')
        self.button_Y['activebackground'] = self.button_Y.cget('background')


    def setLinktoButtons(self,function):
        ''' 
            Syfte: Enables to set a link to the buttons from another file
                and bind it to a given function
            ReturvÃ¤rde: -
            Kommentarer: -
        '''        
        self.function = function
        self.button_R.bind('<ButtonRelease-1>',self.function)
        self.button_G.bind('<ButtonRelease-1>', self.function)
        self.button_B.bind('<ButtonRelease-1>', self.function)
        self.button_Y.bind('<ButtonRelease-1>',self.function)
       

    def disableButtons(self):
        ''' 
            Syfte: Dissconnects the buttonclick to anothe button
            ReturvÃ¤rde: -
            Kommentarer: Used before simulation to avid user interaction
        '''        
        self.button_R.bind('<ButtonRelease-2>',self.nothing)
        self.button_G.bind('<ButtonRelease-2>', self.nothing)
        self.button_B.bind('<ButtonRelease-2>', self.nothing)
        self.button_Y.bind('<ButtonRelease-2>',self.nothing)


    def showFrame(self, bol=None):
        ''' 
            Syfte: Makes the frame visible in the root window
            ReturvÃ¤rde: -
            Kommentarer: The order in which is called relative to the other 
            widgets are important using the pack method.
        '''
        if bol is True:
            self.buttonFrame.pack()
        elif bol is False:
            self.buttonFrame.pack_forget()


    def nothing(self,event):
        pass


    def simulation(self,tmpLevelSeq):
        ''' 
            Syfte: Simulates botton press given a list of colors
            ReturvÃ¤rde: -
            Kommentarer: -
        '''   
        self.disableButtons()                 
        print('Current level seq --->',tmpLevelSeq)        
        time.sleep(1)
        for eachColor in tmpLevelSeq:
            print('---> Computer',eachColor)
            
            if eachColor == 'R':
                self.button_R['activebackground']='white'
                self.button_R.flash()
                self.button_R.after(2000, lambda:self.button_R.configure(activebackground ='red'))          
            elif eachColor == 'G':
                self.button_G['activebackground']='white'
                self.button_G.flash()
                self.button_G.after(2000, lambda:self.button_G.configure(activebackground ='green'))
            elif eachColor == 'B':
                self.button_B['activebackground']='white'
                self.button_B.flash()
                self.button_B.after(2000, lambda:self.button_B.configure(activebackground ='blue'))
            elif eachColor == 'Y':
                self.button_Y['activebackground']='white'
                self.button_Y.flash()
                self.button_Y.after(2000, lambda:self.button_Y.configure(activebackground ='yellow'))
            time.sleep(0.5)

        var_startinfo = "Now it is your turn!!"
        time.sleep(0.4)
        messagebox.showinfo('', var_startinfo)

