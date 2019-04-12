# -*- coding: utf-8 -*-
#Written by Andreé Johnsson <bio13ajn@cs.umu.se> and Hampus Silverlind <bio15hsd@cs.umu.se>
#Course Application Programming in Python, 7.5 Credits at Umea University.
#Usage requires permission by the author.
#
from tkinter import *
from tkinter import messagebox
import time, random

from HighscoreFrame import HighScoreFrame
from LabelFrame_S import LabelFrame_S
from ButtonFrame import ButtonFrame
from ScoreFrame import ScoreFrame
from ScoreSheet import ScoreSheet
from Countdown import Countdown

class mainWindow:
    def __init__(self):
        ''' 
            Syfte: Starts up with an Instructions Popup followed by the game.
            ReturvÃ¤rde: -
            Kommentarer: -
        '''
        self.root = Tk()
        self.root["bg"] = "papaya whip"
        self.startingOrder()
        var_startinfo = "1.A blinking pattern is presented, wait for your turn.\n\n2.Repeat the pattern by pressing the buttons.\n\n3.Submit your highscore.\n\n4.Now you are ready, press start.\n\n5.Pro-tip: The start-button also restarts the level in case you are sleepy..zZzz"
        messagebox.showinfo("What is the game is all about",var_startinfo)

        self.root.mainloop()

    def startingOrder(self):
        ''' 
            Syfte: This function only gets run once when an instance of this class
            is made i.e the program is run and creates the basic framwwork of the hole game.
            ReturvÃ¤rde: -
            Kommentarer: -
        '''
        self.mainWinLayout()
        self.highscoreFrame = HighScoreFrame(self.root)
        self.labelFrame = LabelFrame_S(self.root)
        self.buttonFrame = ButtonFrame(self.root)
        self.scoreFrame = ScoreFrame(self.root)
        self.scoresheet = ScoreSheet()
        
        self.setNewLinksToFrames()
        self.resetButton()


    def mainWinLayout(self):
        ''' 
            Syfte: Center the main window and gives it nice appearence
            ReturvÃ¤rde: -
            Kommentarer: -
        '''
        self.root.title('RGBY-ColorGame 3.0.1')
        self.root.resizable(width=False, height=False)
        width_of_window = 600
        height_of_window = 500
        screen_width = self.root.winfo_screenwidth()
        screen_height = self.root.winfo_screenheight()
        x_coordinate = (screen_width/2-width_of_window/2)
        y_coordinate = (screen_height/2-height_of_window/2)
        self.root.geometry("%dx%d+%d+%d" % (width_of_window,
                                            height_of_window, x_coordinate, y_coordinate))


    def setNewLinksToFrames(self):
        ''' 
            Syfte: To be able to use the buttons in this file
            ReturvÃ¤rde: -
            Kommentarer: -
        '''
        self.labelFrame.setLinktoNavButtons(self.navButtons)
        self.buttonFrame.setLinktoButtons(self.colourButtons)


    def navButtons(self, event):
        ''' 
            Syfte: Menubar response gets handled here and redirected
            ReturvÃ¤rde: -
            Kommentarer: -
        '''
        whichBotton = event.widget.cget('text')

        if whichBotton == 'Start' and self.lives != 0:
            self.startButton()
            print('Start Button',self.tmpLevelSeq)

        elif whichBotton == 'Highscores':
            highscore_var = self.scoresheet.getString()
            self.highscoreFrame.changeHighscoreFrame(highscore_var)
            self.buttonFrame.showFrame(False)
            self.highscoreFrame.showFrame(True)
            self.scoreFrame.showFrame(False)
            print('Highscores Button')

        elif whichBotton == 'Reset':
            print('Reset Button')
            self.resetButton(True)

        elif whichBotton == 'Back' and self.lives != 0:
            self.buttonFrame.showFrame(True)
            self.highscoreFrame.showFrame(False)
            self.scoreFrame.showFrame(False)
            print('Back Button')


    def startButton(self):
        ''' 
            Syfte: Everything that needs to be done before start simulation
            ReturvÃ¤rde: -
            Kommentarer: -
        '''        
        self.scoreFrame.showFrame(False)
        self.tmpLevelSeq = self.levelSeqMaker(self.level)            
        self.highscoreFrame.showFrame(False)
        self.buttonFrame.showFrame(False)
        Countdown(self.root, self.buttonFrame,self.tmpLevelSeq)
        self.buttonFrame.showFrame(True)
        self.setNewLinksToFrames()


    def resetButton(self,bol = None):
        ''' 
            Syfte: Does not start simulaton only restart internals
            ReturvÃ¤rde: 
            Kommentarer: 
        '''
        self.level = 1
        self.lives = 3
        self.tmpLevelSeq = []
        self.labelFrame.showFrame(True)
        self.highscoreFrame.showFrame(False)
        self.labelFrame.chageLabelFrame(self.level, self.lives)

        if bol is True:
            messagebox.showinfo('Restar Done',
            'Now you can give it another try, press start whenever you are ready, good luck :)')
            print('........Reseting Done........\n')


    def colourButtons(self, event):
        ''' 
            Syfte: Sends the colour pressed to be compared
            ReturvÃ¤rde: -
            Kommentarer: Prints which colour to display on terminal 
            for easy use.
        '''
        event.widget.bell(displayof=0)
        whichColour = event.widget.cget('text')       
        self.liveComparison(whichColour)
		
        if whichColour == 'R':
            print('---> user Red')
        elif whichColour == 'G':
            print('---> user Green')
        elif whichColour == 'B':
            print('---> user Blue')
        elif whichColour == 'Y':
            print('---> user Yellow')
		

    def liveComparison(self,colour):
        ''' 
            Syfte: compares the computer seq with the button pressed 
            ReturvÃ¤rde: -
            Kommentarer: -
        '''    
        print('***Level sequence****',self.tmpLevelSeq)
        if self.tmpLevelSeq != []:
            cpUcolor = self.tmpLevelSeq.pop(0)
            if cpUcolor != colour:                               
                self.restartLevel()
            elif cpUcolor == colour and self.tmpLevelSeq == []:
                self.nextLevel()
                print('Next level')


    def nextLevel(self):
        ''' 
            Syfte: upon wining we get popup and change the settings
                    by calling nextlevelcommands 
            ReturvÃ¤rde: -
            Kommentarer: -
        '''
        var_0 = "Nice, you made it to the next round."
        tmpMsg0 = messagebox.showinfo("Winner winner chicken dinner", var_0)
        if tmpMsg0 == 'ok':
            self.nextLevelCommands()


    def nextLevelCommands(self):
        ''' 
            Syfte: Everything that needs to be done in order to go to the
                    next level
            ReturvÃ¤rde: 
            Kommentarer: 
        '''
        self.buttonFrame.showFrame(False)
        self.level = self.level + 1
        self.labelFrame.chageLabelFrame(self.level, self.lives)
        self.tmpLevelSeq = self.levelSeqMaker(self.level)
        Countdown(self.root, self.buttonFrame,self.tmpLevelSeq)
        self.setNewLinksToFrames()
        self.buttonFrame.showFrame(True)


    def restartLevel(self):
        ''' 
            Syfte: check how many life and depending on that it redirects to 
            other functions.
            ReturvÃ¤rde: -
            Kommentarer: -
        '''
        if self.lives > 1:
            var_2 = "Oops you got it wrong, click to restart level"
            tmpMsg2 = messagebox.showinfo("You lost a live", var_2)
            if tmpMsg2 == 'ok':
                self.restartLevelCommands()

        else:
            var_1 = 'You lost, the game will reset, but you can still submit your highscore.'
            tmpMsg1 = messagebox.showwarning("Loser", var_1)
            if tmpMsg1 == 'ok':
                self.buttonFrame.showFrame(False)                
                self.scoreFrame.chageScoreFrame(self.level-1)
                self.scoreFrame.showFrame(True)
                self.resetButton(True)


    def restartLevelCommands(self):
        ''' 
            Syfte: Everything needed to start from scratch
            ReturvÃ¤rde: 
            Kommentarer: 
        '''
        self.buttonFrame.showFrame(False)
        self.lives = self.lives-1
        self.tmpLevelSeq = self.levelSeqMaker(self.level)
        self.labelFrame.chageLabelFrame(self.level, self.lives)
        Countdown(self.root, self.buttonFrame,self.tmpLevelSeq)
        self.setNewLinksToFrames()
        self.buttonFrame.showFrame(True)


    def levelSeqMaker(self,level):
        ''' 
            Syfte: Empties the current level list and randomizes 
                a new one depening on the level.
            ReturvÃ¤rde: 
            Kommentarer: 
        ''' 
        self.tmpLevelSeq = []
        for i in range(level):
            randomColor = random.choice('RYGB')
            self.tmpLevelSeq.append(randomColor)
        return self.tmpLevelSeq


if __name__ == "__main__":
    mainWindow()

