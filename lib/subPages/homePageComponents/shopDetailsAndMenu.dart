import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/shopModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ShopDetailsAndMenu extends StatefulWidget {
  ShopDetailsAndMenu({@required this.data,@required this.size});
   final DocumentSnapshot data;
   final Size size;

  @override
  _ShopDetailsAndMenuState createState() => _ShopDetailsAndMenuState();
}

class _ShopDetailsAndMenuState extends State<ShopDetailsAndMenu> {

  Stream _getStream() {
    var qs = FirebaseFirestore.instance
        .collection("shops")
        //.where('shop_cuisine', arrayContains: widget.cuisine)
        .snapshots();
    print('${qs.single}');
    return qs;
  }

  @override
  Widget build(BuildContext context) {
    final shop = Shop.fromSnapshot(widget.data);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        //appBar: appBarDefault,
        body: StreamBuilder<QuerySnapshot>(
            stream: _getStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(
                  slivers: <Widget>[

                    SliverAppBar(
                      floating: true,
                      stretch: false,
                      //leading: Container(),
                      // Display a placeholder widget to visualize the shrinking size.
                      flexibleSpace: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        // It will cover 20% of our total height
                        height: widget.size.height * 0.6,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: widget.size.height * 0.11,
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
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
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

                      // Make the initial height of the SliverAppBar larger than normal.
                      expandedHeight: 120,
                      backgroundColor: Colors.transparent,
                    ),




                    ///LIST OF SHOPS
                   /* SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          return shopListItem(context,data);
                        },
                        childCount: snapshot.data.docs.length,
                      ),
                    ),*/

                    SliverPadding(
                      padding: EdgeInsets.all(35.0),
                    ),
                  ],
                );
              }
              return Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(secondary))
                  ],
                ),
              );
            }),
      ),
    );
  }
}
