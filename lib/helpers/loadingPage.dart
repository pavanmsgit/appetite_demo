import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:loading_overlay/loading_overlay.dart';


class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            sliverAppBarDefault(size),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: LoadingBouncingLine.square(
                      size: 60.0,
                      backgroundColor: tertiary,
                      borderColor: tertiary,
                      duration: Duration(milliseconds: 500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),);
  }
}


