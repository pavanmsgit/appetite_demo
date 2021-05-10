import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/subPages/homePageComponents/shopListItemComponent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListOfShops extends StatefulWidget {
  ListOfShops({@required this.cuisine, @required this.size});
  final String cuisine;
  final Size size;

  @override
  _ListOfShopsState createState() => _ListOfShopsState();
}

class _ListOfShopsState extends State<ListOfShops> {
  Stream _getStream() {
    var qs = FirebaseFirestore.instance
        .collection("shops")
        .where('shop_cuisine', arrayContains: widget.cuisine)
        .snapshots();
    print('${qs.single}');
    return qs;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: StreamBuilder<QuerySnapshot>(
            stream: _getStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(
                  slivers: <Widget>[
                    ///APP BAR
                    sliverAppBarDefaultWithBackButton(widget.size,context),

                    ///STATIC TEXT
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(left: 25, top: 10, bottom: 5),
                        child: Text(
                          "Oder your favorite ${widget.cuisine} now !",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),

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
