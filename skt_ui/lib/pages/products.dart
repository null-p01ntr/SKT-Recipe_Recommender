import 'package:flutter/material.dart';
import 'package:skt_ui/pages/home.dart';
import 'package:sizer/sizer.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class ProductClass {
  String name;
  String date;
  int remind;
  ProductClass({this.name, this.date, this.remind});
  static List<ProductClass> getProducts() {
    return <ProductClass>[
      ProductClass(name: 'muz', date: '01-02-2021', remind: 2),
      ProductClass(name: 'elma', date: '10-02-2021', remind: 2),
      ProductClass(name: 'armut', date: '01-03-2021', remind: 2),
      ProductClass(name: 'sut', date: '10-01-2021', remind: 2),
      ProductClass(name: 'yumurta', date: '20-01-2021', remind: 2)
    ];
  }
}

class _ProductsState extends State<Products> {
  List<ProductClass> products;

  DataTable productTable() {
    return DataTable(
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
                          width: MediaQuery.of(context).size.width * 0.05,
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
    );
  }

  @override
  void initState() {
    products = ProductClass.getProducts();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: textStyle,
        ),
      ),
      body: Column(
        children: <Widget>[
          Center(
            heightFactor: 0.146.h,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.orangeAccent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: productTable(),
            ),
          )
        ],
      ),
    );
  }
}
