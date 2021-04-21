import 'package:appetite_demo/auth/googleSignIn.dart';
import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/FoodModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appetite_demo/Data/FoodData.dart';
import 'package:appetite_demo/widgets/FoodCategory.dart';
import 'package:appetite_demo/widgets/SearchBar.dart';
import 'package:appetite_demo/widgets/FoodBought.dart';
import 'package:appetite_demo/Pages/orderPage.dart';
import 'package:appetite_demo/Pages/notificationPage.dart';
import 'package:appetite_demo/Pages/mapsPage.dart';
import 'package:appetite_demo/Pages/profilePage.dart';
import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  List<Widget> pages;
  Widget currentPage;
  Home homePage;
  OrderPage orderPage;
  MapsPage mapsPage;
  NotificationPage notificationPage;
  ProfilePage profilePage;

  List<String> data;
  String uid, name, email, photoUrl;

  @override
  void initState() {
    getUserData();
    super.initState();
    super.initState();
    homePage = Home();
    orderPage = OrderPage();
    mapsPage = MapsPage();
    notificationPage = NotificationPage();
    profilePage = ProfilePage();
    pages = [homePage, orderPage, mapsPage, notificationPage, profilePage];
    currentPage = homePage;
  }

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

  final List<FoodData> _foods = foods;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      bottomNavigationBar: BubbledNavigationBar(
        defaultBubbleColor: Colors.blue,
        onTap: (index) {
          // handle tap
        },
        items: <BubbledNavigationBarItem>[
          BubbledNavigationBarItem(
            icon: Icon(CupertinoIcons.home, size: 30, color: Colors.red),
            activeIcon:
                Icon(CupertinoIcons.home, size: 30, color: Colors.white),
            title: Text(
              'Home',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          BubbledNavigationBarItem(
            icon: Icon(CupertinoIcons.shopping_cart,
                size: 30, color: Colors.purple),
            activeIcon: Icon(CupertinoIcons.shopping_cart,
                size: 30, color: Colors.white),
            title: Text(
              'Order',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          BubbledNavigationBarItem(
            icon: Icon(CupertinoIcons.map, size: 30, color: Colors.teal),
            activeIcon: Icon(CupertinoIcons.map, size: 30, color: Colors.white),
            title: Text(
              'Map',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          BubbledNavigationBarItem(
            icon: Icon(CupertinoIcons.bell, size: 30, color: Colors.deepOrange),
            activeIcon:
                Icon(CupertinoIcons.bell_solid, size: 30, color: Colors.white),
            title: Text(
              'Notification',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          BubbledNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled,
                size: 30, color: Colors.cyan),
            activeIcon: Icon(CupertinoIcons.profile_circled,
                size: 30, color: Colors.white),
            title: Text(
              'Profile',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20.0, top: 50.0, right: 20.0),
        children: <Widget>[
          Center(
            child: Image.asset(
              "assets/logo2.png",
              width: 200,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          SearchBar(),
          SizedBox(
            height: 15.0,
          ),
          Text(
            "What do you want to eat today?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          SizedBox(
            height: 5.0,
          ),
          FoodCategory(),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Trending Restaurants",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "View All",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.orangeAccent),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Column(
            children: _foods.map(buildFoodBought).toList(),
          )
        ],
      ),
    );
  }

  Widget buildFoodBought(FoodData food) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: BoughtFood(
        imagePath: food.imagePath,
        id: food.id,
        name: food.name,
        price: food.price,
        discount: food.discount,
        ratings: food.ratings,
        category: food.category,
      ),
    );
  }
}
