from flask import Flask, jsonify, request
from googlesearch import search
import pandas as pd
import datetime as dt
import json

app = Flask(__name__)


@app.route('/')
def hello_world():
    return 'SKT Running'


@app.route('/products', methods=['GET', 'POST'])
def products():
    global new_product
    if(request.method == 'POST'):
        products = pd.read_json(r"./skt_ui/data/database.json")
        new_product = json.loads(request.data.decode('utf-8'))
        adding = pd.DataFrame(
            [[new_product['name'], new_product['date'],
                new_product['remind'], new_product['notified']]],
            columns=list(['name', 'date', 'remind', 'notified']))
        products = products.append(adding, ignore_index=True)
        products.to_json(r"./skt_ui/data/database.json", indent=4)
        return ''
    elif(request.method == 'GET'):
        products = pd.read_json(r"./skt_ui/data/database.json")
        products = products.sort_values(by="date")
        products = products.reset_index(drop=True)
        products["date"] = products["date"].dt.strftime("%d-%m-%Y")
        return jsonify(products.to_dict(orient='index'))
        # return jsonify(new_product)


@app.route('/search', methods=['GET', 'POST'])
def searchRecipe():
    global response
    if(request.method == 'POST'):
        response = json.loads(request.data.decode('utf-8'))
    elif(request.method == 'GET'):
        return jsonify(search(response['searchFor'] + ' recipes', 10))


if __name__ == '__main__':
    app.run()
