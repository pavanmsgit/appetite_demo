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

class AccountPage extends StatefulWidget {
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController controllerUserName = TextEditingController();
  //TextEditingController controllerUserEmail = TextEditingController();
  TextEditingController controllerUserPhone = TextEditingController();

  bool editName = false;
  bool editNumber = false;
  bool editPhoto = false;

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

  checkEditName(userName) {
    if (editName == false) {
      return Container(
        height: 50,
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: Text(
                      'NAME : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w400),
                    ),
                  )),
              Center(
                  child: Padding(
                padding: EdgeInsets.only(left: 0),
                child: Text(
                   userName,
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              )),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.edit,
              size: 20,
              color: tertiary,
            ),
            onPressed: () {
              setState(() {
                editName = true;
              });
            },
          ),
        ),
      );
    } else {
      return ListTile(
        title: Center(
            child: Padding(
          padding: EdgeInsets.only(left: 30),
          child: TextField(
            controller: controllerUserName,
            keyboardType: TextInputType.name,
            cursorColor: Colors.black,
            autofocus: false,
            maxLength: 15,
            autocorrect: true,
            onChanged: (text) {},
            textAlign: TextAlign.justify,
            decoration: InputDecoration(
              hintMaxLines: 1,
              hintText: "Name",
              alignLabelWithHint: true,
              hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w100,
                  color: Colors.grey),
            ),
          ),
        )),
        trailing: IconButton(
          icon: Icon(
            Icons.check_rounded,
            size: 30,
            color: tertiary,
          ),
          onPressed: () async {
            FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .update({'user_name': controllerUserName.text});
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString('name', controllerUserName.text);

            EasyLoading.showSuccess('Updated Name');
            setState(() {
              editName = false;
            });
          },
        ),
      );
    }
  }

  checkEditPhone(userPhone)  {
    if (editNumber == false) {

      return Container(
        height: 50,
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: Text(
                      'PHONE : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w400),
                    ),
                  )),
              Center(
                  child: Padding(
                padding: EdgeInsets.only(left: 0),
                child: Text(
                  userPhone,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                ),
              )),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.edit,
              size: 20,
              color: tertiary,
            ),
            onPressed: () {
              setState(() {
                editNumber = true;
              });
            },
          ),
        ),
      );
    } else {
      return ListTile(
        title: Center(
            child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: controllerUserPhone,
            keyboardType: TextInputType.phone,
            cursorColor: Colors.black,
            autofocus: false,
            maxLength: 10,
            autocorrect: true,
            onChanged: (text) {},
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
        )),
        trailing: IconButton(
          icon: Icon(
            Icons.check_rounded,
            size: 30,
            color: tertiary,
          ),
          onPressed: () async {
            FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .update({'user_phone': controllerUserPhone.text});
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString('phone', controllerUserPhone.text);

            EasyLoading.showSuccess('Updated Phone Number');
            setState(() {
              editNumber = false;
            });
          },
        ),
      );
    }
  }

  checkProfilePhotoUrl(data) {
    String userPhotoUrl = data;
    if (userPhotoUrl == null || userPhotoUrl == '') {
      return InkWell(
        onTap: () async {},
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Image.asset('assets/profile.png'),
            ),
          ],
        ),
      );
    } else {
      return InkWell(
        onTap: () async {},
        child: Stack(
          children: <Widget>[
            CircleAvatar(
                backgroundImage: NetworkImage(data),
                radius: 60,
                backgroundColor: Colors.white),
          ],
        ),
      );
    }
  }



  addNumberToSharedPrefs(num) async {
      final SharedPreferences prefs =
          await SharedPreferences.getInstance();
      prefs.setString('phone', num);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        // appBar: appBarDefault,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData){
                var userDetails = snapshot.data;



                return CustomScrollView(
                  slivers: <Widget>[
                    sliverAppBarDefault(size),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [card(context, userDetails)],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(35.0),
                    ),
                  ],
                );
              }

              return LoadingPage();
            }),
      ),
    );
  }

  Widget card(BuildContext context, data) {
    var userName = data["user_name"];
    var userEmail = data["user_email"];
    var userPhone = data["user_phone"];
    var userLogo = data["user_logo"];
    addNumberToSharedPrefs(userPhone);

    final auth = Provider.of<AuthProvider>(context);
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
        ),

        ///NAME AND EMAIL
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              checkProfilePhotoUrl(userLogo),
              checkEditName(userName),
              checkEditPhone(userPhone),
              Container(
                height: 40,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: Text(
                              'EMAIL : ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400),
                            ),
                          )),
                      Center(
                          child: Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Text(
                          userEmail,
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 20.0,
          color: Colors.black,
        ),

        ///ROW OF ICONS FOR NOTIFICATIONS , PAYMENTS AND ORDERS
        Container(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 0),
                height: 100,
                width: 100,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications_none_rounded,
                        color: tertiary,
                      ),
                      tooltip: 'NOTIFICATIONS',
                    )),
              ),
              VerticalDivider(
                width: 1.0,
                color: Colors.black,
              ),
              Container(
                padding: EdgeInsets.only(right: 0),
                height: 100,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: IconButton(
                    icon: Icon(
                      Icons.payment,
                      color: tertiary,
                    ),
                    tooltip: 'PAYMENT',
                  ),
                ),
              ),
              VerticalDivider(
                width: 1.0,
                color: Colors.black,
              ),
              Container(
                padding: EdgeInsets.only(right: 0),
                height: 100,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: IconButton(
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      color: tertiary,
                    ),
                    tooltip: 'ORDERS HISTORY',
                  ),
                ),
              ),
            ],
          ),
        ),

        Divider(
          height: 20.0,
          color: Colors.black,
        ),
        SizedBox(height: 2),

        ListTile(
          title: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'About',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),

        Divider(
          thickness: 0.8,
          height: 2.0,
          color: Colors.black,
        ),

        ListTile(
          title: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Contact us',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),

        ListTile(
          title: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Send Feedback',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),

        ListTile(
          onTap: () {
            auth.logout(context);
          },
          title: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Logout',
              style: TextStyle(
                  color: tertiary, fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.logout,
              color: tertiary,
            ),
            onPressed: () {
              auth.logout(context);
            },
          ),
        ),

        /* ///LOGOUT BUTTON
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                auth.logout(context);
              },
              child: Container(
                width: 120,
                height: 40,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [tertiary, tertiary]),
                    borderRadius: BorderRadius.circular(40.0),
                    boxShadow: [
                      BoxShadow(
                          color: tertiary.withOpacity(.3),
                          offset: Offset(0.4, 0.4),
                          blurRadius: 6.0)
                    ]),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Center(
                      child: Text('LOGOUT',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),*/
      ],
    );
  }
}
