import 'package:appetite_demo/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';


class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:  Center(
      child: LoadingBumpingLine.square(
        size: 60.0,
        //inverted: true,
        backgroundColor: tertiary,
        borderColor: tertiary,
        duration: Duration(milliseconds: 500),
      ),
    ),);
  }
}
