import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:appetite_demo/auth/googleSignIn.dart';
import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/subPages/accountPage.dart';
import 'package:appetite_demo/subPages/homePage.dart';
import 'package:appetite_demo/subPages/mapsPage.dart';
import 'package:appetite_demo/subPages/searchPage.dart';
import 'package:appetite_demo/subPages/orderPage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _selectedPageIndex = 0;

  List<String> data;
  String uid, name, email, photoUrl;

  //INTIALIZE PAGE WITH USER DATA
  @override
  void initState() {
    getUserData();
    super.initState();
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
        onPressed: () {
          Navigator.of(context).push(changeScreenUp(MapsPage()));
          print('Floating Action Button Pressed');
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
