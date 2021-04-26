import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:flutter/material.dart';


class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefault,
      body: Center(child: Text('ACCOUNT PAGE'),),
    );
  }
}
