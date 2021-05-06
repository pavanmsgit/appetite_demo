import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/mainScreens/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
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
        .collection("orders")
        .where('order_by_uid', isEqualTo: uid)
        .snapshots();
    print('${qs.single}');
    return qs;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dismissible(
      direction: DismissDirection.vertical,
      key: UniqueKey(),
      onDismissed: (_) => Navigator.of(context).pop(),
      background: LoadingPage(),
      child: SafeArea(
        child: Scaffold(
          body: StreamBuilder<QuerySnapshot>(
              stream: _getStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        floating: true,
                        stretch: false,
                        leading: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              size: 35,
                            )),
                        flexibleSpace: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          // It will cover 20% of our total height
                          height: size.height * 0.6,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: size.height * 0.11,
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
                        expandedHeight: 120,
                        backgroundColor: Colors.transparent,
                      ),

                      ///LIST OF ITEMS
                      /* SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            DocumentSnapshot data = snapshot.data.docs[index];
                            return orderItemList(context, data, size);
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
                return LoadingPage();
              }),

          // resizeToAvoidBottomInset: false,
        ),
      ),
    );
  }
}
