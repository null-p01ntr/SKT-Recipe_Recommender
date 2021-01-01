from googlesearch import search


class searchRecipe:
    def __init__(self, searchFor):
        self.searchFor = searchFor

    def searchResults(self):
        # devide string to list
        # search for every combination
        return search(" recipes " + self.searchFor, 5)
