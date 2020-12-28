from datetime import datetime
from datetime import timedelta
from numpy.core.fromnumeric import product
from search import searchRecipe
import pandas as pd
import time
import threading


class liveData:
    def __init__(self, products, date):
        self.products = products
        self.date = date


class updateThread(threading.Thread):
    def __init__(self, data):
        threading.Thread.__init__(self)
        self.data = data

    def run(self):
        notified = False
        while 1:
            self.data.products = pd.read_json(r"database.json")
            self.data.date = datetime.today()
            toSearch = ""
            for i in self.data.products.index:
                _date = self.data.products.at[i, "date"]
                _remind = self.data.products.at[i, "remind"]
                _name = self.data.products.at[i, "name"]

                left = _date-self.data.date
                notif = timedelta(days=int(_remind*7))
                if(left < notif):
                    toSearch += _name+" "
            if(not notified):
                fileWriter = open("notifications.txt", "a")
                fileWriter.write(
                    toSearch + "is about expire, heres some recepies you can use:\n")
                srch = searchRecipe(toSearch)
                res = srch.searchResults()
                for url in res:
                    fileWriter.write("%s\n" % url)
                notified = True
                fileWriter.close()
        time.sleep(0.5)
