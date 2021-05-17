import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:appetite_demo/auth/googleSignIn.dart';
import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/shopModel.dart';
import 'package:appetite_demo/subPages/accountPage.dart';
import 'package:appetite_demo/subPages/homePage.dart';
import 'package:appetite_demo/subPages/mapsPage.dart';
import 'package:appetite_demo/subPages/searchPage.dart';
import 'package:appetite_demo/subPages/orderPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain>
    with SingleTickerProviderStateMixin {
  int _selectedPageIndex = 0;

  List<String> data;
  String uid, name, email, photoUrl, phone;
  var lat, lng;
  GeoPoint point;

  List<UserModelCustom> list = [];

  //INTIALIZE PAGE WITH USER DATA
  @override
  void initState() {
    getUserData();
    addLocationLive();
    //fetchData();
    super.initState();
  }

  Future<List<UserModelCustom>> fetchData() async {
    await FirebaseFirestore.instance.collection("users").get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        UserModelCustom userModelCustom = UserModelCustom(
            value.docs[i]['user_id'],
            value.docs[i]['user_name'],
            value.docs[i]['user_phone'],
            value.docs[i]['user_location'],
          value.docs[i]['user_gender'],
        value.docs[i]['user_college_name']);
        list.add(userModelCustom);
        //print('HEY $list');
      }
    });
    return list;
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

  addLocationLive() async {
    Location location = new Location();
    location.getLocation().then((res) {
      lat = res.latitude;
      lng = res.longitude;
      point = GeoPoint(lat, lng);

      insertLocationToFirestore(); //this function has not to be a stream
    });
  }

  insertLocationToFirestore() async {
    print(
        'UPDATING USER CURRENT LOCATION ${point.latitude}  ${point.longitude}');
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

  ///LOCATION STUFF

  Location location = new Location();

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

          fetchData().whenComplete(() {
            print('CHECK LIST $list');
            Navigator.of(context).push(changeScreenUp(MapsPage(userCustomModelFromPreviousDataFetch: list,)));
          });


          print('Floating Action Button Pressed');

          list.clear();
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
