import pandas as pd

#test variables
date = "01-01-2021"
products = pd.read_json(r"database.json")

def updateData():
	print("update")

def main_menu(x):
	if(x==9):
		print("Select action: \n 1. Products \n 2. Search Recepie \n (0 to exit) \n")
		x = int(input(""))
		main_menu(x)
	elif(x==1):
		products = pd.read_json(r"database.json")
		print(products)
		opt = int(input("type 1 to add, 2 to change reminder, 0 to go back\n"))
		if(opt==1):
			name = input("enter name: ")
			date = input("enter date: ")
			adding = pd.DataFrame(
				[[name, date, 2]], columns=list(["Products", "Expiry Dates", "Remind Before(weeks)"]))
			products=products.append(adding, ignore_index=True)
		elif(opt==2):
			indx = int(input("Which product you want to change the reminder of(enter index): "))
			remind = input("Enter reminder deadline in weeks: ")
			products.at[indx, "Remind Before(weeks)"] = remind
			print(products)
		elif(opt==0):
			main_menu(9)
			
		products.to_json(r"database.json")
		main_menu(1)
	elif(x==2):
		name = input("Search Recepie with: ")
		#print results
		main_menu(9)
	else: return 0


main_menu(9)
