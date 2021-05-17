import 'dart:io';
import 'dart:math';

import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddReview extends StatefulWidget {
  AddReview({@required this.size, @required this.docId});
  final Size size;
  final String docId;

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  bool isLoading = false;
  int itemType = 0;
  double finalRating = 1.0;

  TextEditingController controllerHeadline = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();

  List<String> data;
  String uid, name, email, photoUrl;

  var imageFile;

  //INTIALIZE PAGE WITH USER DATA
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  //CHECKING USER DATA
  getUserData() async {
    data = await UserData().getUserData();
    UserData().getUserData().then((result) {
      setState(() => data = result);
    });
    print('DATA CHECK FROM SHARED PREFERENCES ${data[0]}');
    uid = data[0];
    name = data[1];
    email = data[2];
    photoUrl = data[3];
  }

  addBottomBadgeToAddItem() {
    if (controllerHeadline.text.isNotEmpty == true &&
        controllerDescription.text.isNotEmpty == true) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          height: 60,
          width: double.infinity,
          child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ADD REVIEW",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  )
                ],
              ),
            ),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(1.0),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(tertiary),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: tertiary),
                ),
              ),
            ),
            onPressed: () async {
              ///IMPORTANT ADDING DATA TO FIRE STORE
              ///AND FIREBASE STORAGE

              setState(() {
                isLoading = true;
              });

              var rand = new Random();

              String finalNum = rand.nextInt(100000).toString() +
                  rand.nextInt(10000).toString();

              print(finalNum);

              FirebaseFirestore.instance
                  .collection('shops')
                  .doc(widget.docId)
                  .collection('shop_reviews')
                  .add({
                'review_id': finalNum,
                'review_by_id': uid,
                'review_by_name': name,
                'review_by_photo': photoUrl,
                'headline': controllerHeadline.text,
                'description': controllerDescription.text,
                'ratings': finalRating
              });

              EasyLoading.showSuccess('Review Added');
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return LoadingOverlay(
      color: tertiary,
      progressIndicator: LoadingBumpingLine.square(
        size: 75.0,
        backgroundColor: secondary,
        borderColor: secondary,
        duration: Duration(milliseconds: 500),
      ),
      isLoading: isLoading,
      child: SafeArea(
          child: Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("shops")
                .doc('$uid')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var list = snapshot.data;

                return CustomScrollView(
                  slivers: <Widget>[
                    sliverAppBarDefaultWithBackButtonDown(size, context),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "ADD A REVIEW",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Center(
                          child: Text(
                            "NOTE : PLEASE ENTER ALL THE FIELDS.",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w200),
                          ),
                        ),
                      ),
                    ),

                    ///RATING BAR
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                        child: Center(
                          child: RatingBar.builder(
                            initialRating: 1,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,

                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.restaurant,
                              color: secondary,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                finalRating = rating;
                              });
                              print(finalRating);
                            },
                          ),
                        ),
                      ),
                    ),

                    ///ITEM NAME AND PRICE TEXT FIELDS
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ///ITEM NAME
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 25),
                              child: TextField(
                                controller: controllerHeadline,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.black,
                                autofocus: false,
                                minLines: 1,
                                maxLines: 1,
                                maxLength: 20,
                                onChanged: (text) {
                                  setState(
                                    () {},
                                  );
                                },
                                autocorrect: true,
                                textAlign: TextAlign.justify,
                                decoration: InputDecoration(
                                  hintMaxLines: 1,
                                  hintText: "Headline",
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w100,
                                      color: Colors.grey),
                                ),
                              ),
                            ),

                            ///ITEM PRICE
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 25),
                              child: TextField(
                                controller: controllerDescription,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.black,
                                autofocus: false,
                                maxLength: 50,
                                maxLines: 1,
                                autocorrect: true,
                                onChanged: (text) {
                                  setState(
                                    () {},
                                  );
                                },
                                textAlign: TextAlign.justify,
                                decoration: InputDecoration(
                                  hintMaxLines: 1,
                                  hintText: "Description",
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w100,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverPadding(
                      padding: EdgeInsets.only(bottom: 50),
                    )
                  ],
                );
              }
              return LoadingPage();
            }),

        bottomNavigationBar: addBottomBadgeToAddItem(),
      )),
    );
  }
}
