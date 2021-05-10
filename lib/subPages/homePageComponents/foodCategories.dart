import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/shopModel.dart';
import 'package:appetite_demo/subPages/homePageComponents/listOfShops.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Stream _getStream() {
  var qs = FirebaseFirestore.instance.collection("categories").snapshots();
  print('${qs.single}');
  return qs;
}

Widget listOfCategories(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
      stream: _getStream(),
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
                      padding: EdgeInsets.only(left: 20,right: 10,top: 5,bottom: 5),
                      child: foodCategories(context, data),
                    );
                  },
                  childCount: snapshot.data.docs.length,
                ),
              ),
              /*SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisExtent: 120),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    DocumentSnapshot data = snapshot.data.docs[index];
                    return foodCategories(context, data);
                  },
                  childCount: snapshot.data.docs.length,
                ),
              ),*/
            ],
          );
        }
        return LoadingPage();
      });
}

Widget foodCategories(BuildContext context, data) {
  final categories = Categories.fromSnapshot(data);
  Size size = MediaQuery.of(context).size;
  String categoryName = categories.category_name;
  String categoryPhotoURL = categories.category_photo_url;


  return GestureDetector(
      onTap: (){
         Navigator.of(context).push(changeScreenFadeTransition(ListOfShops(cuisine: categories.category_name,size: size,)));
      },
      child: Card(color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
        elevation: 0.0,
        child: Stack(
          children: <Widget>[
            Container(
              width: size.width / 4.5,
              height: size.height / 8,
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  categoryPhotoURL,
                  width: size.width * 0.25,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 60,
              bottom: 7,
              left: 0,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(0),bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10) ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.10),
                      ),
                    ],
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                        child: Text(
                          categoryName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.0,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  )
              ),)
          ],
        ),
      ),
    );
}
