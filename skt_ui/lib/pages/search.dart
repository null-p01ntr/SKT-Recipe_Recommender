import 'package:flutter/material.dart';
import 'package:skt_ui/pages/home.dart';
import 'package:sizer/sizer.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
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
          'Search Recipe',
          style: textStyle,
        ),
      ),
      body: Column(
        children: <Widget>[
          emptySpace,
          Center(
            child: Container(
              width: 95.0.w,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90),
                  ),
                  hintText: 'Search for a recipe',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
