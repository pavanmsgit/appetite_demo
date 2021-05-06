import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/shopModel.dart';
import 'package:appetite_demo/subPages/homePageComponents/listOfShops.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      });
}

Widget foodCategories(BuildContext context, data) {
  final categories = Categories.fromSnapshot(data);
  Size size = MediaQuery.of(context).size;
  String categoryName = categories.category_name;
  String categoryPhotoURL = categories.category_photo_url;


  return Column(
    children: [
      Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0,),
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
          // height:size.height /5,
          width: size.width * 0.25,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 3.0,
            child: Column(
              children: <Widget>[
                SizedBox(height: 0.0),
                GestureDetector(
                  onTap: () async {
                     Navigator.of(context)
                            .push(changeScreenFadeTransition(
                            ListOfShops(cuisine: categories.category_name,size: size,)));
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: size.height / 12,
                        //width: size.width / 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Image.network(
                            categoryPhotoURL,
                            width: size.width * 0.25,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
                GestureDetector(
                  onTap: () async {},
                  child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              categoryName,
                              style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          )
                        ],
                      )),
                ),
                SizedBox(height: 2.0),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
