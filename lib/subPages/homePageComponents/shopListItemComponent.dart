import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/models/shopModel.dart';
import 'package:appetite_demo/subPages/homePageComponents/shopDetailsAndMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                 Navigator.of(context)
                    .push(changeScreenFadeTransition(ShopDetailsAndMenu(
                  data: data,
                   size: size,
                )));
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
                        fit: BoxFit.cover,
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