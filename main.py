from update import liveData, updateThread
from search import searchRecipe
import pandas as pd
import datetime
import time
import sys

# test variables
products = pd.read_json(r"database.json")
_liveData = liveData(products)


def main_menu(x):
    if(x == 9):
        print("Select action: \n 1. Products \n 2. Search Recepie \n (0 to exit) \n")
        x = int(input(""))
        main_menu(x)
    elif(x == 1):
        print(_liveData.products)
        opt = int(input("type 1 to add, 2 to change reminder, 0 to go back\n"))
        if(opt == 1):
            name = input("enter name: ")
            date = input("enter date(YYYY-mm-dd): ")
            year, month, day = map(int, date.split('-'))
            date = datetime.date(year, month, day)
            products = _liveData.products
            updateData.lock.acquire()
            adding = pd.DataFrame(
                [[name, date, 2]], columns=list(["name", "date", "remind"]))
            products = products.append(adding, ignore_index=True)
            products.to_json(r"database.json", indent=4)
            updateData.lock.release()
            time.sleep(0.5)
            main_menu(1)
        elif(opt == 2):
            indx = int(
                input("Which product you want to change the reminder of(enter index): "))
            remind = input("Enter reminder deadline in weeks: ")
            updateData.lock.acquire()
            _liveData.products.at[indx, "remind"] = remind
            _liveData.products.to_json(r"database.json", indent=4)
            updateData.lock.release()
            time.sleep(0.5)
            main_menu(1)
        else:
            main_menu(9)
    elif(x == 2):
        name = input("Search Recepie with: ")
        res = searchRecipe(name)
        print(*res.searchResults(), sep="\n")
        main_menu(9)
    else:
        sys.exit()


updateData = updateThread(_liveData)
updateData.daemon = True
updateData.start()
main_menu(9)
