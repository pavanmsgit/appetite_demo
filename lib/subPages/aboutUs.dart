import 'package:appetite_demo/auth/googleSignIn.dart';
import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/displaySize.dart';
import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  List<String> data;
  String uid, name, email, photoUrl, phone;

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
    phone = data[4];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        // appBar: appBarDefault,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("about_shop")
                .doc('273BGxiTpO9xBaoBOuKk')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var infoModel = snapshot.data;

                return CustomScrollView(
                  slivers: <Widget>[
                    sliverAppBarDefaultWithBackButtonDown(size, context),
                    SliverPadding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    SliverToBoxAdapter(
                        child: Container(
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        'assets/logo2.png',
                      ),
                    )),


                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 0),
                        color: Colors.transparent,
                        child: Column(
                          children: [card(context, infoModel, size)],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(20.0),
                    ),
                  ],
                );
              }

              return LoadingPage();
            }),
      ),
    );
  }

  Widget card(BuildContext context, data, size) {
    var description = data["description"];
    final auth = Provider.of<AuthProvider>(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '      $description',
                  style: TextStyle(fontSize: 14,backgroundColor: Colors.transparent),
                  textAlign: TextAlign.center,

                )
              ],
            ),
          ),
        ),

        ///ABOUT DATA

        Divider(
          thickness: 0.8,
          height: 10.0,
          color: Colors.black,
        ),

        Padding(
          padding: EdgeInsets.only(top: 20),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///CONTACT US BUTTON
            InkWell(
              onTap: () async {
                launch(
                    "mailto:foodappappetite@gmail.com?subject=Contact Us&body=ID:$uid \n User Name: $name \n Phone Number: $phone \n \n");
              },
              child: Container(
                width: 160,
                height: 40,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [tertiary, tertiary]),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: tertiary.withOpacity(.3),
                          offset: Offset(0.4, 0.4),
                          blurRadius: 8.0)
                    ]),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Center(
                      child: Text('Contact Us',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ),
            ),

            ///SEND FEEDBACK BUTTON
            InkWell(
              onTap: () async {
                launch(
                    "mailto:foodappappetite@gmail.com?subject=User Feedback&body=ID:$uid \n User Name: $name \n Phone Number: $phone \n \n");
              },
              child: Container(
                width: 160,
                height: 40,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [secondary, secondary]),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: secondary.withOpacity(.3),
                          offset: Offset(0.4, 0.4),
                          blurRadius: 8.0)
                    ]),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Center(
                      child: Text('Send Feedback',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
