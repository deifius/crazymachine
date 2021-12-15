#!/usr/bin/env python3

import tkinter as tk

class Application(tk.Frame):
	def __init__(self, master=None):
		self.confs = {
			'RWS200' :	(9600, 'N', 8, 1),
			'LX'	:	(4800, 'N', 8, 1),
			'BOS' 	:	(4800, 'E', 7, 1)
		}
		super().__init__(master)
		self.pack()
		self.create_widgets()
	def create_widgets(self):
		self.recalibrate = tk.Button(self)
		self.recalibrate['text'] = "Get device info"
		self.recalibrate['command'] = self.get_info
		self.recalibrate.pack(side="top")
		confblock = "device:\nbaud:\nparity:\nbits:\nstop:\nConfig:"
		self.devinfo = tk.Label(self, text=confblock, fg='green')
		#self.devinfo.destroy()
		self.devinfo.pack()
		self.bottom = tk.Frame(self)
		self.bottom.pack(side='bottom', fill="both", expand=True)
		self.reconf = tk.Button(self, text="reconf",fg="black", command=self.config_win)
		self.reconf.pack(in_=self.bottom, side="left")
		self.quit = tk.Button(self, text="quit", fg="red", command=self.master.destroy)
		self.quit.pack(in_=self.bottom, side="right")
	def get_info(self):
		configuration = input('pick LX, RWS200 or BOS\n')
		confblock = "device:\tHMP155\n"+\
			"baud:\t"+str(self.confs[configuration][0])+\
			"\nparity:\t"+str(self.confs[configuration][1])+\
			"\nbits:\t"+str(self.confs[configuration][2])+\
			"\nstop:\t"+str(self.confs[configuration][3])+\
			"\nConfig:\t"+configuration
		self.devinfo.config(text=confblock)
	def config_win(self):
		print('new window will pop up')
root = tk.Tk()
app = Application(master=root)
app.mainloop()
