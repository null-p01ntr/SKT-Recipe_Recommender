import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skt_ui/pages/home.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class ProductClass {
  String name;
  String date;
  int remind;
  ProductClass({this.name, this.date, this.remind});

  // ProductClass.fromJson(Map<String, dynamic> json)
  //     : name = json['name'],
  //       date = json['date'],
  //       remind = json['remind'];

  // Map<String, dynamic> toJson() => {
  //       'name': name,
  //       'date': date,
  //       'remind': remind,
  //     };
}

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<ProductClass> products = List<ProductClass>();

  Future<List<ProductClass>> fetchProducts() async {
    var response = await http.read(new Uri.http("10.0.2.2:5000", "/products"));
    List decoded = jsonDecode(response).values.toList();
    var _products = List<ProductClass>();
    for (int i = 0; i < decoded.length; i++) {
      _products.add(
        ProductClass(
            name: decoded[i]['name'],
            date: decoded[i]['date'],
            remind: decoded[i]['remind']),
      );
    }
    return _products;
  }

  @override
  void initState() {
    fetchProducts().then((value) {
      setState(() {
        products = value;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MaterialButton(
            child: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                SlideRoute(page: Notifications(), offset: Offset(1, 0)),
              );
            },
          ),
        ],
        title: Text(
          'Products',
          style: textStyle,
        ),
      ),
      body: Column(
        children: <Widget>[
          /*FutureBuilder(future:),*/
          emptySpace,
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.orangeAccent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text('Name'),
                    numeric: false,
                    tooltip: "Name of the product",
                  ),
                  DataColumn(
                    label: Text('Expiry Date'),
                    numeric: false,
                    tooltip: "Expiry date of the product",
                  ),
                  DataColumn(
                    label: Text('Remind Before'),
                    numeric: true,
                    tooltip: "how many weeks before notify to use the product",
                  ),
                ],
                rows: products
                    .map(
                      (product) => DataRow(
                        cells: [
                          DataCell(Text(product.name)),
                          DataCell(Text(product.date)),
                          DataCell(
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(product.remind.toString()),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                  Icon(Icons.edit)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
