import 'dart:io';
import 'dart:math';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:appetite_demo/auth/googleSignIn.dart';
import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';

import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/dataModels.dart';
import 'package:appetite_demo/subPages/accountPage.dart';
import 'package:appetite_demo/subPages/homePage.dart';
import 'package:appetite_demo/subPages/mapsPage.dart';

import 'package:appetite_demo/subPages/searchPage.dart';
import 'package:appetite_demo/subPages/orderPage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:trust_location/trust_location.dart';

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain>
    with SingleTickerProviderStateMixin {
  int _selectedPageIndex = 0;

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







  List<UserModelCustom> listUsersInfo = [];

  List<ShopModelCustom> listShopInfo = [];

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _message = '';
  String tokenMain;

  _registerOnFirebase() {
    //_firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.getToken().then((token) {
      print(token);
      setState(() {
        tokenMain = token;
      });
    });
  }

  ///SAVING AUTH TOKEN OF THE USER
  saveDeviceToken() async {
    // Get the token for this device
    String fcmToken = await FirebaseMessaging.instance.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tokens')
          .doc(fcmToken);

      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem
      });

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', fcmToken);

      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }

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
          value.docs[i]['shop_overall_rating'],
        );
        listShopInfo.add(shopModelCustom);
        //print('HEY $list');
      }
    });
    return listShopInfo;
  }

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




  //Location location = new Location();
  //LocationData _locationData;
  var lat, lng;
  GeoPoint point;


  ///GEOLOCATOR
  Position _currentPosition;
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;



  @override
  void initState() {

    getUserData();
    print('CALLING LOCATION ADD LIVE METHOD');
    addLocationLive();
    print('CALLED LOCATION ADD LIVE METHOD');
    _registerOnFirebase();
    saveDeviceToken();

    super.initState();
  }


  Future addLocationLive() async{
    geoLocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((position) {
      setState(() {
        _currentPosition = position;
         point = GeoPoint(position.latitude,position.longitude);
        insertLocationToFirestore();
      });
    });
  }


 /* Future addLocationLive() async {
   *//* _locationData = await location.getLocation().whenComplete(() {
      setState(() {
        lat = _locationData.latitude;
        lng = _locationData.longitude;
        point = GeoPoint(lat, lng);
      });

      insertLocationToFirestore();
    });*//*
    }*/


  insertLocationToFirestore() async {
    //print('UPDATING USER CURRENT LOCATION ${_locationData.latitude}  ${_locationData.longitude}');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'user_location': point});
    print('USER LIVE LOCATION UPDATED');
  }

  CurvedAnimation curve;

  //SWITCHING PAGES FOR MAIN SCREEN
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
      print(_selectedPageIndex);
      print('hello');
    });
  }


  //ICON LIST FOR BOTTOM NAVIGATION BAR
  final iconList = <IconData>[
    Icons.home,
    Icons.search_rounded,
    Icons.receipt_long_rounded,
    Icons.account_circle_rounded,
  ];


  //LIST OF PAGES WHICH WILL BE SWITCHED WITH THE HELP OF BOTTOM NAVIGATION BAR
  final List<Widget> _pageOption = [
    HomePage(),
    SearchPage(),
    OrderPage(),
    AccountPage()
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    Size size = MediaQuery.of(context).size;

   // addLocationLive();



    return Scaffold(
      ///ASSIGNS DIFFERENT COMPONENTS WHICH ARE MENTIONED IN THE LIST OF WIDGETS _pageOption.
      body: Container(child: _pageOption[_selectedPageIndex]),

      ///CART FAB BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondary,
        child: Icon(
          Icons.location_pin,
          color: tertiary,
        ),
        onPressed: () async {
         /* AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: Random().nextInt(100000),
              channelKey: 'basic_channel',
              title: 'Simple Notification',
            ),
          );*/

           addLocationLive().whenComplete(() {
             fetchDataUser().whenComplete(() {
               print('CHECK LIST $listUsersInfo');
               fetchDataShop().whenComplete(() {
                 Navigator.of(context).push(changeScreenUp(MapsPage(
                   userCustomModelFromPreviousDataFetch: listUsersInfo,
                   shopCustomModelFromPreviousDataFetch: listShopInfo,
                 )));
               });
             });
           });



          listUsersInfo.clear();
          listShopInfo.clear();
        },
      ),

      ///POSITION OF CART BUTTON
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      ///BNB WITH FOUR OPTIONS
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        backgroundColor: tertiary,
        activeColor: secondary,
        notchMargin: 15,
        inactiveColor: Colors.white,
        activeIndex: _selectedPageIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 0,
        rightCornerRadius: 0,
        onTap: (index) => setState(
          () => _selectPage(index),
        ),
      ),

      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
    );
  }
}
