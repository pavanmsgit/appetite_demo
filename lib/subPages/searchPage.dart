import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController seachController = TextEditingController();


  Stream _getStream() {
    var qs = FirebaseFirestore.instance
        .collection("shops").where('shop_name_search', arrayContains:seachController.text)
        .snapshots();
    print('${qs.single}');
    return qs;
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(

        body: StreamBuilder<Object>(
          stream: _getStream(),
          builder: (context, snapshot) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  stretch: false,
                  leading: Container(),
                  flexibleSpace: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    // It will cover 20% of our total height
                    height: size.height * 0.6,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: size.height * 0.11,
                          decoration: BoxDecoration(
                            color: tertiary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 50,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            alignment: Alignment.center,
                            margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            //height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(70),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 10),
                                  blurRadius: 40,
                                  color: secondary.withOpacity(0.23),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/logo2.png",
                                width: 100,
                                height: 50,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  expandedHeight: 120,
                  backgroundColor: Colors.transparent,
                ),
                
                
              ],
            );
          }
        )
      ),
    );
  }
}
