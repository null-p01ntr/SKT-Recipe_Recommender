from datetime import datetime
from datetime import timedelta
import pandas as pd
import time
import threading
from search import searchRecipe

class liveData:
	def __init__(self, products, date):
		self.products = products
		self.date = date
		
	def checkDate(self, exDate, remind, name):
		fileWriter = open("notifications.txt", "w")
		today = self.date
		left = exDate-today
		notif = timedelta(days=int(remind*7))
		if(left<notif):
			fileWriter.write(name+" is about expire, heres some recepies you can use: ")
			srch = searchRecipe(name)
			#fileWriter.write(*srch.searchResults(), sep = "\n")
			time.sleep(3)
		fileWriter.close()

class updateThread(threading.Thread):
	def __init__(self, data):
			threading.Thread.__init__(self)
			self.data=data

	def run(self):
		notified = False
		while 1:
			self.data.products = pd.read_json(r"database.json")
			self.data.date = datetime.today()
			#scan whole dataframe
			testDate = self.data.products.at[7, "date"]
			testRem = self.data.products.at[7, "remind"]
			testName = self.data.products.at[7, "name"]

			if not notified:
				self.data.checkDate(testDate, testRem, testName)
				notified = True
			time.sleep(2)
