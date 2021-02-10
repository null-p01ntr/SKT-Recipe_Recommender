from flask import Flask, jsonify, request
from googlesearch import search
import pandas as pd
import datetime as dt
import json

app = Flask(__name__)


@app.route('/add_test', methods=['GET', 'POST'])
def test():
    global response
    if(request.method == 'POST'):
        new_product = request.data
        response = new_product['name'] + new_product['date']
        print(response)
        return ''
    else:
        return jsonify({'response': response})


@app.route('/products', methods=['GET', 'POST'])
def products():
    products = pd.read_json(r"./skt_ui/data/database.json")
    if(request.method == 'POST'):
        new_product = request.data
        new_product = json.loads(new_product.decode('utf-8'))
        response = new_product['name'] + new_product['date']
        # adding = pd.DataFrame(new_product, columns=list(
        # ["name", "date", "remind", "notified"]))
        # products = products.append(adding, ignore_index=True)
        # products.to_json(r"database.json", indent=4)
        return ''
    elif(request.method == 'GET'):
        products = products.sort_values(by="date")
        products = products.reset_index(drop=True)
        products["date"] = products["date"].dt.strftime("%d-%m-%Y")
        return jsonify(products.to_dict(orient='index'))


@app.route('/search', methods=['GET'])
def searchFor(ing):
    return jsonify(search(ing + " recipes", 5))


if __name__ == '__main__':
    app.run(debug=True)
