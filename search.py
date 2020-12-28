from googlesearch import search

class searchRecipe:
	def __init__(self, searchFor):
		self.searchFor = searchFor

	def searchResults(self):
		return search(" recipes with " + self.searchFor, 5)
