from datetime import datetime
from datetime import timedelta
from numpy.core.fromnumeric import product
from search import searchRecipe
import pandas as pd
import time
import threading


class liveData:
    def __init__(self, products):
        self.products = products
        date = datetime.today()


class updateThread(threading.Thread):
    def __init__(self, data):
        threading.Thread.__init__(self)
        self.lock = threading.Lock()
        self.data = data

    def run(self):
        while 1:
            self.data.products = pd.read_json(r"database.json")
            self.data.date = datetime.today()
            for i in self.data.products.index:
                _date = self.data.products.at[i, "date"]
                _remind = self.data.products.at[i, "remind"]
                _name = self.data.products.at[i, "name"]

                left = _date-self.data.date
                notif = timedelta(days=int(_remind*7))
                if(left < notif and not self.data.products.at[i, "notified"]):
                    fileWriter = open("notifications.txt", "a")
                    fileWriter.write(
                        _name + " is about expire, heres some recepies you can use:\n")
                    srch = searchRecipe(_name)
                    res = srch.searchResults()
                    for url in res:
                        fileWriter.write("%s\n" % url)
                    fileWriter.close()
                    self.data.products.at[i, "notified"] = True
                    self.data.products.to_json(r"database.json", indent=4)
        time.sleep(0.5)
