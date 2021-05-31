import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/dataModels.dart';
import 'package:appetite_demo/subPages/homePageComponents/advestiseBanner.dart';
import 'package:appetite_demo/subPages/homePageComponents/foodCategories.dart';
import 'package:appetite_demo/subPages/homePageComponents/listOfShops.dart';
import 'package:appetite_demo/subPages/homePageComponents/shopDetailsAndMenu.dart';
import 'package:appetite_demo/subPages/homePageComponents/shopListItemComponent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading_animations/loading_animations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream _getStream() {
    var qs = FirebaseFirestore.instance
        .collection("shops")
        /* .where('newsPostDate', isEqualTo: finalCurrentDate)
        .where('newsStatus', isEqualTo: true)
        .orderBy("createdTime")*/
        .snapshots();
    print('${qs.single}');
    return qs;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: _getStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(
                  slivers: <Widget>[
                    ///APP BAR
                    sliverAppBarDefault(size),


                    ///AD POSTERS
                    SliverToBoxAdapter(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("ad_posters").doc('hsAJdES8CAfNvqd3VdQD').snapshots(),
                        builder: (context, snapshot){
                          if (snapshot.hasData){
                            var list = snapshot.data;
                          return checkIPosterTypeAndReturnLayout(list["poster_list"] ,size);}
                          else return Center(
                            child: LoadingBouncingLine.square(
                              size: 60.0,
                              backgroundColor: tertiary,
                              borderColor: tertiary,
                              duration: Duration(milliseconds: 500),
                            ),
                          );
                        },
                      )
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(left: 25, top: 20, bottom: 10),
                        child: Text(
                          "Order food from your favorite cuisines !",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),

                    ///FOOD CATEGORIES GRID VIEW
                    SliverToBoxAdapter(
                        child: Container(
                      width: size.width * 0.95,
                      height: size.height / 6,
                      child: listOfCategories(context),
                    )),

                    ///STATIC TEXT
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(left: 25, top: 10, bottom: 10),
                        child: Text(
                          "What's cooking in the kitchen today?",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),

                    ///LIST OF SHOPS
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          return shopListItem(context, data);
                        },
                        childCount: snapshot.data.docs.length,
                      ),
                    ),

                    SliverPadding(
                      padding: EdgeInsets.only(top: 30),
                    ),

                    SliverToBoxAdapter(
                        child: Container(
                          width: 80,
                          height: 80,
                          child: Image.asset(
                            'assets/logo2.png',
                          ),
                        )),

                    SliverPadding(
                      padding: EdgeInsets.only(bottom: 60),
                    ),
                  ],
                );
              }


              return LoadingPage();
            }),
      ),
    );
  }
}
