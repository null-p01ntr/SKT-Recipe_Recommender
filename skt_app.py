from flask import Flask, jsonify
from googlesearch import search
import pandas as pd
import datetime as dt

app = Flask(__name__)


@app.route('/', methods=['GET'])
@app.route('/products', methods=['GET'])
def index():
    products = pd.read_json(r"./skt_ui/data/database.json")
    products = products.sort_values(by="date")
    products = products.reset_index(drop=True)
    products["date"] = products["date"].dt.strftime("%d-%m-%Y")
    return jsonify(products.to_dict(orient='index'))


@app.route('/search', methods=['GET'])
def searchFor(ing):
    return jsonify(search(ing + " recipes", 5))


if __name__ == '__main__':
    app.run(debug=True)
