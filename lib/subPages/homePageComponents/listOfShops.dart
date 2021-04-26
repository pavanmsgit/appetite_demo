import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/shopModel.dart';
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
        // appBar: appBarDefault,
        /*appBar: AppBar(
          backgroundColor: secondary,
          foregroundColor: secondary,
          toolbarHeight: 40,
          shadowColor: secondary,

        ),*/
        body: StreamBuilder<QuerySnapshot>(
            stream: _getStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(
                  slivers: <Widget>[
                    ///APP BAR
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

  Widget shopListItem(BuildContext context, data) {
    final shop = Shop.fromSnapshot(data);
    Size size = MediaQuery.of(context).size;

    List<dynamic> list = shop.shop_cuisine;
    print(list.join(" | "));
    String concatenated = list.join(" | ");

    //String categoryName = categories.category_name;
    //String categoryPhotoURL = categories.category_photo_url;
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 10,
              color: Colors.black.withOpacity(0.10),
            ),
          ],
        ),
        //height:size.height * 0.4,
        width: size.width * 0.95,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          elevation: 3.0,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  /* Navigator.of(context)
                    .push(changeScreenFadeTransition(PostView(
                  index: 2,
                  data: data,
                )));*/
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: size.height / 4,
                      width: size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        child: Image.network(
                          shop.shop_logo,
                          width: size.width * 0.95,
                          height: 200,
                          fit: BoxFit.fill,
                          //cancelToken: cancellationToken,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.0),
              GestureDetector(
                onTap: () async {},
                child: Padding(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            shop.shop_name,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(height: 0.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.0, right: 0.0, top: 5),
                    child: Text(
                      '${shop.shop_overall_rating} ',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 0.0, right: 5.0, top: 5),
                      child: Icon(
                        Icons.star,
                        size: 12,
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0, right: 0.0, top: 5),
                    child: Text(
                      concatenated,
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
              SizedBox(height: 2.0),
            ],
          ),
        ),
      ),
    );
  }
}
