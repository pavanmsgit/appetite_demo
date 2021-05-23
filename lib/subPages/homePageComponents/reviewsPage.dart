import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/dataModels.dart';
import 'package:appetite_demo/subPages/homePageComponents/listOfShops.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Stream _getStream(docId) {
  print('THIS IS SHOP REVIEWS PAGE $docId');
  var qs = FirebaseFirestore.instance.collection("shops").doc(docId).collection('shop_reviews').snapshots();
  return qs;
}

Widget listOfReviews(BuildContext context,docId) {
  return StreamBuilder<QuerySnapshot>(
      stream: _getStream(docId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomScrollView(
            scrollDirection: Axis.horizontal,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    DocumentSnapshot data = snapshot.data.docs[index];
                    return Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: shopReviewListItems(context, data,snapshot.data.docs.length),
                    );
                  },
                  childCount: snapshot.data.docs.length,
                ),
              ),
            ],
          );
        }
        return LoadingPage();
      });
}

 shopReviewListItems(BuildContext context, data,len) {
  final shopReviews = ShopReviews.fromSnapshot(data);
  Size size = MediaQuery.of(context).size;
  String shopReviewByName = shopReviews.review_by_name;
  String shopReviewByPhoto = shopReviews.review_by_photo;
  String shopHeadline = shopReviews.headline;
  String shopRatings = shopReviews.ratings.toString();
  String shopDescription = shopReviews.description;

  if(len==0){
    return Center(
      child: Text(
        'NO REVIEWS',
        style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
            fontWeight: FontWeight.bold),
      ),
    );
  }
  else {
    return Container(
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          elevation: 3.0,
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  width: 280,
                  height: 60,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
                    tileColor: tertiary,
                    leading: Container(
                      padding: EdgeInsets.only(top: 0),
                      height: 90,
                      width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          shopReviewByPhoto,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 0,right: 20,bottom: 5),
                          child: Text(
                            shopReviewByName,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 0.0, right: 5.0, top: 0,bottom: 5),
                          child: Text(
                            '$shopRatings',
                            style: TextStyle(fontSize: 13,color: Colors.white,),
                          ),
                        ),
                        Padding(
                            padding:
                            EdgeInsets.only(left: 0.0, right: 20.0, top: 0,bottom: 5),
                            child: Icon(
                              Icons.star,
                              size: 18,
                              color: secondary,
                            )),
                      ],
                    ),

                  ),

                ),
              ),


              Padding(
                padding:
                EdgeInsets.only(top: 15,bottom: 10,left: 10,right: 10),
                child: Text(
                  shopHeadline,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ),


              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding:
                  EdgeInsets.only(left: 20.0, right: 20.0, top: 5,bottom: 10),
                  child: Text(
                    shopDescription,
                    style: TextStyle(
                        fontSize: 10,color: Colors.grey, fontWeight: FontWeight.w400),
                  ),
                ),
              ),

            ],
          )),
    );
  }




}
