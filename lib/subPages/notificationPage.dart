import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:flutter/material.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefault,
      body: Center(child: Text('NOTIFICATION PAGE'),),
    );
  }
}
