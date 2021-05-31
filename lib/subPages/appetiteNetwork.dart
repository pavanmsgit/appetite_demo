import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/auth/userModel.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/dataModels.dart';
import 'package:appetite_demo/subPages/mapsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

class AppetiteNetwork extends StatefulWidget {
  const AppetiteNetwork({Key key}) : super(key: key);

  @override
  _AppetiteNetworkState createState() => _AppetiteNetworkState();
}

class _AppetiteNetworkState extends State<AppetiteNetwork> {


  //INTIALIZE PAGE WITH USER DATA
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  List<UserModelCustom> listUsersInfo = [];

  List<ShopModelCustom> listShopInfo = [];

  UserModelCustom userModelCustomSelected;

  Future<List<ShopModelCustom>> fetchDataShop() async {
    await FirebaseFirestore.instance.collection("shops").get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        ShopModelCustom shopModelCustom = ShopModelCustom(
            value.docs[i]['shop_id'],
            value.docs[i]['shop_name'],
            value.docs[i]['shop_seller_number'],
            value.docs[i]['shop_location'],
            value.docs[i]['shop_cuisine'],
            value.docs[i]['shop_logo'],
            value.docs[i]['shop_overall_rating']);
        listShopInfo.add(shopModelCustom);
        //print('HEY $list');
      }
    });
    return listShopInfo;
  }

  Future<void> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launched;

  Future<List<UserModelCustom>> fetchDataUser() async {
    await FirebaseFirestore.instance.collection("users").get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        UserModelCustom userModelCustom = UserModelCustom(
            value.docs[i]['user_id'],
            value.docs[i]['user_name'],
            value.docs[i]['user_phone'],
            value.docs[i]['user_location'],
            value.docs[i]['user_gender'],
            value.docs[i]['user_college_name'],
            value.docs[i]['user_logo'],value.docs[i]['token'],);
        listUsersInfo.add(userModelCustom);
        //print('HEY $list');
      }
    });
    return listUsersInfo;
  }

  List<String> data;
  String uid, name, email, photoUrl, phone,token;


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
    token = data[5];
  }


  Future mappingUserData(UserDataModelMain users) async {
    setState(() {
      UserModelCustom model = UserModelCustom(
          users.user_id,
          users.user_name,
          users.user_phone,
          users.user_location,
          users.user_gender,
          users.user_college_name,
          users.user_logo,
          users.token);
      userModelCustomSelected = model;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where('user_id', isNotEqualTo: uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var userDetails = snapshot.data;
              return CustomScrollView(
                slivers: <Widget>[
                  sliverAppBarDefaultWithBackButtonDown(size, context),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Center(
                        child: Text(
                          'APPETITE NETWORK',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        DocumentSnapshot data = snapshot.data.docs[index];
                        final users = UserDataModelMain.fromSnapshot(data);
                        return Column(
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.only(top: 10, left: 10, right: 10),
                              height: 220,
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            tertiary,
                                            secondary,
                                          ]),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0)),
                                        ),
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight:
                                                    Radius.circular(20.0)),
                                          ),
                                          tileColor: tertiary,
                                          horizontalTitleGap: 20,
                                          leading: Container(
                                            width: 60,
                                            height: 100,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                users.user_logo,
                                                //width: size.width * 0.95,
                                                height: 60,
                                                fit: BoxFit.cover,
                                                //cancelToken: cancellationToken,
                                              ),
                                            ),
                                          ),
                                          title: Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 0.0),
                                                child: Text(
                                                  users.user_name,
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: SingleChildScrollView(
                                            child: Row(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 0.0,
                                                      right: 0.0,
                                                      top: 5),
                                                  child: Text(
                                                    '${users.user_college_name} ',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    ///GENDER AND PHONE
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 0.0,
                                                  right: 0.0,
                                                  top: 10),
                                              child: Text(
                                                'GENDER',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 0.0,
                                                  top: 5),
                                              child: Text(
                                                'PHONE NUMBER',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 0.0,
                                                  right: 0.0,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Text(
                                                '${users.user_gender} ',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 0.0,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Text(
                                                '${users.user_phone} ',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 10),
                                          child: GestureDetector(
                                            onTap: () async {
                                              await mappingUserData(users)
                                                  .whenComplete(() {
                                                if (userModelCustomSelected !=
                                                    null) {
                                                  print(
                                                      '${userModelCustomSelected.name}');
                                                }
                                                fetchDataUser()
                                                    .whenComplete(() {
                                                  print(
                                                      'CHECK LIST $listUsersInfo');
                                                  fetchDataShop()
                                                      .whenComplete(() {
                                                    Navigator.of(context).push(
                                                        changeScreenUp(MapsPage(
                                                      userCustomModelFromPreviousDataFetch:
                                                          listUsersInfo,
                                                      shopCustomModelFromPreviousDataFetch:
                                                          listShopInfo,
                                                      userSelectedModel:
                                                          userModelCustomSelected,
                                                    )));
                                                  });
                                                });

                                                listUsersInfo.clear();
                                                listShopInfo.clear();
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              decoration: BoxDecoration(
                                                gradient:
                                                    LinearGradient(colors: [
                                                  tertiary,
                                                      tertiary,
                                                ]),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      "Live ",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Icon(
                                                      Icons.location_pin,
                                                      color: secondary,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 10),
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (users.user_phone == null) {
                                                EasyLoading.showInfo(
                                                    'No Permission to call');
                                              } else {
                                                _launched = makePhoneCall(
                                                    'tel:${users.user_phone}');
                                              }
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              decoration: BoxDecoration(
                                                gradient:
                                                    LinearGradient(colors: [
                                                      secondary,
                                                      secondary,
                                                ]),
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      "Call ",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Icon(
                                                      Icons.phone,
                                                      color: tertiary,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      childCount: snapshot.data.docs.length,
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 30),
                  ),

                  SliverToBoxAdapter(
                      child: Container(
                        width: 80,
                        height: 80,
                        child: Image.asset(
                          'assets/logo2.png',
                        ),
                      )),

                  SliverPadding(
                    padding: EdgeInsets.only(bottom: 60),
                  ),
                ],
              );
            }

            return LoadingPage();
          }),
    ));
  }
}
