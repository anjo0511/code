# -*- coding: utf-8 -*-
#Written by Andreé Johnsson <bio13ajn@cs.umu.se> and Hampus Silverlind <bio15hsd@cs.umu.se>
#Course Application Programming in Python, 7.5 Credits at Umea University.
#Usage requires permission by the author.
#
from tkinter import *
from ScoreSheet import ScoreSheet

class ScoreFrame():
    def __init__(self,root):
        ''' 
            Syfte: Makes a frame to take in the highscore
            ReturvÃ¤rde: -
            Kommentarer: -
        ''' 
        self.root = root       
        self.scoreFrameLayout()
        self.inputFrame["bg"] = "papaya whip"
        self.scoreSheet = ScoreSheet()
        

    def scoreFrameLayout(self):
        ''' 
            Syfte: layout of the frame 
            ReturvÃ¤rde: -
            Kommentarer: -
        '''           
        self.inputFrame = Frame(self.root, bd=4, relief='solid', padx=50)    
        
        self.entry1 = Entry(self.inputFrame)                  
        self.label_meassage=Label(self.inputFrame,bd=1,font='Times 11 bold',padx=10,pady=5,bg="papaya whip")        
        self.button1 = Button(self.inputFrame,font='Times 12 bold',text='Submit',bg='red',bd=7,relief='raised')
        
        self.button1.bind('<ButtonRelease-1>',self.storeHighScore)

        self.scoreVariable = StringVar()
        spacer1 = Label(self.inputFrame,bg="papaya whip")
        nameLabel = Label(self.inputFrame,text='Name: ',font='Times 12 bold',bg= "papaya whip") 
        infoLabel = Label(self.inputFrame,text='Submit your record',font='Times 12 bold',pady=15,bg="papaya whip")
        levelLable = Label(self.inputFrame,textvariable= self.scoreVariable ,font='Times 12 bold',pady=5,bg="papaya whip")
        
        self.chageScoreFrame('')              
       
        infoLabel.grid(           row=0, columnspan=2)
        levelLable.grid(          row=1, columnspan=2)
        nameLabel.grid(           row=2, column=0)
        self.entry1.grid(         row=2, column=1)
        spacer1.grid(             row=3, columnspan=2)
        self.button1.grid(        row=4, columnspan=2)
        self.label_meassage.grid( row=5, columnspan=2)
    

    def chageScoreFrame(self,level):
        ''' 
            Syfte: changes the score frame
            ReturvÃ¤rde: -
            Kommentarer: Makes the level global avalible for storeHighScore()
        '''  
        self.level = level      
        self.scoreVariable.set('Level: '+ str(self.level))
    

    def storeHighScore(self,event):
        ''' 
            Syfte: Define rules for the kind of entry, the game expects
            that is predefined lenght and returns meassages to the user
            in order to get the correct input and later stores is in the higscore list
            ReturvÃ¤rde: -
            Kommentarer: -
        '''
        name = self.entry1.get()
        if name == '':
            self.label_meassage['text']= 'Submit a name'
            self.label_meassage.after(1000, lambda: self.label_meassage.config(text=''))
            self.entry1['bg']= '#f08080'            
            self.entry1.after(300,lambda: self.entry1.config(bg='white'))
            
        elif not len(name) > 15:
            self.scoreSheet.scoreWrite(name,self.level)                   
            self.entry1.delete(0,END)
            self.label_meassage['text']= 'Thanks '
            self.label_meassage.after(700, lambda: self.label_meassage.config(text=''))
            self.inputFrame.after(600, lambda: self.inputFrame.pack_forget())
           
        else:
            self.entry1['bg']= '#f08080'            
            self.entry1.after(300,lambda: self.entry1.config(bg='white'))
            self.label_meassage['text']= 'Shorter, less than 15 characters'
            self.label_meassage.after(1000, lambda: self.label_meassage.config(text=''))            


    def showFrame(self, bol=None):
        ''' 
            Syfte: Shows hides frame
            ReturvÃ¤rde: -
            Kommentarer: -
        '''         
        if bol is True:
            self.inputFrame.pack()
        elif bol is False:
            self.inputFrame.pack_forget()  


