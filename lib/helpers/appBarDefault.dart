import 'package:flutter/material.dart';


AppBar appBarDefault = AppBar(
  backgroundColor: Colors.white,
  //leading: Container(),
  title: Center(
    child: Image.asset(
      "assets/logo2.png",
      width: 200,
      height: 60,
      fit: BoxFit.contain,
    ),
  ),
  centerTitle: true,
  elevation: 0.8,
);
