import 'package:flutter/material.dart';
import 'package:skt_ui/pages/home.dart';
import 'package:sizer/sizer.dart';
import 'package:simple_url_preview/simple_url_preview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchFor = '';
  final _formkeyItem = GlobalKey<FormState>();
  List<dynamic> results = new List(10);

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
        body: Container(
          child: Column(
            children: [
              emptySpace,
              Container(
                width: 95.0.w,
                child: Form(
                  key: _formkeyItem,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      hintText: 'Search for a recipe',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSaved: (value) {
                      searchFor = value;
                    },
                    onFieldSubmitted: (String str) async {
                      setState(() {
                        searchFor = str;
                      });
                      final post = await http.post(
                        'http://10.0.2.2:5000/search',
                        body: jsonEncode({'searchFor': searchFor}),
                      );
                      final response =
                          await http.get("http://10.0.2.2:5000/search");
                      results = json.decode(response.body);
                    },
                  ),
                ),
              ),
              emptySpace,
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
              )
            ],
          ),
        )

        //
        //
        );
  }
}
