import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/loadingPage.dart';

import 'package:appetite_demo/mainScreens/homeMain.dart';

import 'package:appetite_demo/mainScreens/registerUser.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PreHome extends StatefulWidget {
  const PreHome({Key key}) : super(key: key);

  @override
  _PreHomeState createState() => _PreHomeState();
}

class _PreHomeState extends State<PreHome> {
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

  Stream _getStream() {
    var qs = FirebaseFirestore.instance
        .collection("users")
        // .doc(uid)
        .where('user_id', isEqualTo: uid)
        .snapshots();
    print('${qs.single}');
    return qs;
  }

  getStatus(len) {
    print('PRINTING THE LENGTH OF THE DATA STREAM $len');

    if (len == 0) {
      return RegisterUser();
    } else if (len == 1) {
      return HomeMain();
    } else {
      return LoadingPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: _getStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return getStatus(snapshot.data.docs.length);
              }
              return LoadingPage();
            }),
      ),
    );
  }
}
