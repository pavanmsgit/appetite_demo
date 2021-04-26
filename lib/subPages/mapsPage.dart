import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:flutter/material.dart';


class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefault,
      body: Center(child: Text('MAPS PAGE'),),
    );
  }
}
