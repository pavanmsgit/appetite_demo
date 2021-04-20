import 'package:appetite_demo/helpers/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//  splash screen

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/logo.png",
                  width: width,
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 20),
          ),
          Center(

              child: CircularProgressIndicator(
                backgroundColor: primary,
            valueColor: AlwaysStoppedAnimation<Color>(secondary),
          ))
        ],
      ),
    );
  }
}
