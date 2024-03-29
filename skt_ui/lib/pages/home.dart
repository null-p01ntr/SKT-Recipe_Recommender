import 'package:flutter/gestures.dart';
import 'package:skt_ui/pages/search.dart';
import 'package:skt_ui/pages/products.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:date_field/date_field.dart';
import 'package:simple_url_preview/simple_url_preview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skt_ui/main.dart' as m;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

//Global Vars
Color active = Colors.orange;
Color inactive = Colors.grey;
TextStyle textStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
SizedBox emptySpace = SizedBox(height: 3.0.h);

bool debug = false;
String host = debug
    ? "http://10.0.2.2:5000/"
    : "https://skt-recipe-recommender.herokuapp.com/";

class _HomeState extends State<Home> {
  int currentTab = 1;
  final List<Widget> screens = [
    Products(),
    Search(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Products();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizerUtil().init(constraints, orientation);
        return Scaffold(
          body: PageStorage(
            child: currentScreen,
            bucket: bucket,
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                SlideRoute(page: Add(), offset: Offset(0, 1)),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 10,
            child: Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MaterialButton(
                        minWidth: 0,
                        onPressed: () {
                          setState(() {
                            currentScreen = Products();
                            currentTab = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.assignment,
                              color: currentTab == 1 ? active : inactive,
                            ),
                            Text(
                              'Products',
                              style: TextStyle(
                                color: currentTab == 1 ? active : inactive,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 38.0.w,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        minWidth: 0,
                        onPressed: () {
                          setState(() {
                            currentScreen = Search();
                            currentTab = 2;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.search,
                              color: currentTab == 2 ? active : inactive,
                            ),
                            Text(
                              'Search',
                              style: TextStyle(
                                color: currentTab == 2 ? active : inactive,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  DateTime selectedDate = DateTime.now();
  String product_name = '';
  final _formkeyName = GlobalKey<FormState>();
  final _formkeyDate = GlobalKey<FormState>();

  void addProduct() async {
    final validation = _formkeyName.currentState.validate() &
        _formkeyDate.currentState.validate();
    if (validation) {
      _formkeyName.currentState.save();
      _formkeyDate.currentState.save();
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_downward,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Add product',
          style: textStyle,
        ),
      ),
      body: SingleChildScrollView(
        dragStartBehavior: DragStartBehavior.down,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30.0.h),
              Container(
                width: 95.0.w,
                child: Form(
                  key: _formkeyName,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      hintText: 'Enter Product Name',
                      hintStyle: textStyle.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                      suffixIcon: Icon(Icons.camera_alt),
                    ),
                    onSaved: (value) {
                      product_name = value;
                    },
                  ),
                ),
              ),
              SizedBox(height: 5.0.h),
              Container(
                  width: 95.0.w,
                  child: Form(
                    key: _formkeyDate,
                    child: DateTimeField(
                      selectedDate: selectedDate,
                      onDateSelected: (DateTime date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                      mode: DateFieldPickerMode.date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2077),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                        suffixIcon: Icon(Icons.camera_alt),
                      ),
                      label: 'Enter Expiry Date',
                      textStyle: textStyle.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  )),
              emptySpace,
              RaisedButton(
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90)),
                onPressed: () async {
                  addProduct();
                  var post = jsonEncode({
                    'name': product_name,
                    'date': selectedDate.millisecondsSinceEpoch + 10800000,
                    'remind': 2,
                    'notified': false,
                  });
                  final response = await http.post(
                    host + '/products',
                    body: post,
                  );
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Add',
                  style: textStyle.copyWith(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<dynamic> results = new List(10);

  void suggest() async {
    final post = await http.post(
      host + '/search',
      body: jsonEncode({'searchFor': 'avocado'}),
    );
    final response = await http.get(host + "/search");
    results = json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      suggest();
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Notifications",
          style: textStyle,
        ),
      ),
      body: Column(
        children: [
          emptySpace,
          Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Text(
                  'Avocado is about expire, heres some recepies you can use: ',
                  style: textStyle.copyWith(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  textWidthBasis: TextWidthBasis.longestLine,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return SimpleUrlPreview(
                  url: results[index],
                  previewHeight: 150,
                  previewContainerPadding: EdgeInsets.all(7),
                  titleStyle: textStyle,
                  descriptionLines: 2,
                  descriptionStyle: textStyle.copyWith(
                      fontWeight: FontWeight.normal, fontSize: 17),
                  siteNameStyle: textStyle.copyWith(fontSize: 13),
                  imageLoaderColor: Colors.white,
                );
              },
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: RaisedButton(
              child: Text('Test Notification Trigger'),
              onPressed: () async {
                await m.showNotification('Avocado');
              },
            ),
          ),
        ],
      ),
    );
  }
}

//ANIMATIONS
class SlideRoute extends PageRouteBuilder {
  final Widget page;
  final Offset offset;
  SlideRoute({this.page, this.offset})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: offset,
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
