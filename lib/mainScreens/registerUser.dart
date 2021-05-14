import 'dart:io';
import 'dart:math';

import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';

import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/shopModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:loading_animations/loading_animations.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key key}) : super(key: key);

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  TextEditingController controllerUserPhone = TextEditingController();

  bool isLoading = false;

  List<String> data;
  String uid, name, email, photoUrl;

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

  addBottomBadgeToAddStore() {
    if (controllerUserPhone.text.length == 10) {
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
                    "REGISTER",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  )
                ],
              ),
            ),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(1.0),
              foregroundColor: MaterialStateProperty.all<Color>(primary),
              backgroundColor: MaterialStateProperty.all<Color>(tertiary),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: tertiary),
                ),
              ),
            ),
            onPressed: () async {
              ///IMPORTANT ADDING DATA TO FIRESTORE
              ///AND FIREBASE STORAGE






                setState(() {
                  isLoading = true;
                });

                var rand = new Random();

                String finalNum = rand.nextInt(100000).toString() +
                    rand.nextInt(10000).toString() +
                    rand.nextInt(1000000).toString();

                print(finalNum);

                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.setString('phone', controllerUserPhone.text);

                FirebaseFirestore.instance.collection('users').doc(uid).set({
                  'user_id': uid,
                  'user_name': name,
                  'user_logo': photoUrl,
                  'user_email': email,
                  'user_phone': controllerUserPhone.text,
                  'user_registered_timestamp': DateTime.now(),
                });

                EasyLoading.showSuccess('Registered',
                    maskType: EasyLoadingMaskType.custom);

              // Navigator.pop(context);
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final localizations = MaterialLocalizations.of(context);

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
            body: CustomScrollView(
              slivers: <Widget>[
                sliverAppBarDefault(size),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Welcome To Appetite !",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "PLEASE ENTER YOUR PHONE NUMBER, TO CONTINUE",
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w200),
                      ),
                    ),
                  ),
                ),

                ///PHONE
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ///PHONE NUMBER
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 25),
                          child: TextField(
                            controller: controllerUserPhone,
                            keyboardType: TextInputType.phone,
                            cursorColor: Colors.black,
                            autofocus: false,
                            maxLength: 10,
                            autocorrect: true,
                            onChanged: (text) {
                              setState(
                                () {
                                  var sellerNumber = controllerUserPhone.text;
                                  print(sellerNumber);
                                },
                              );
                            },
                            textAlign: TextAlign.justify,
                            decoration: InputDecoration(
                              hintMaxLines: 1,
                              hintText: "Phone Number",
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

                SliverToBoxAdapter(
                    child: Container(
                  width: 80,
                  height: 120,
                  child: Image.asset(
                    'assets/logo2.png',
                  ),
                )),

                SliverPadding(padding: EdgeInsets.only(bottom: 100))
              ],
            ),
            bottomSheet: addBottomBadgeToAddStore(),
          ),
        ));
  }
}
