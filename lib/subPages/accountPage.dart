import 'package:appetite_demo/auth/googleSignIn.dart';
import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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

  checkProfilePhotoUrl(data) {
    String userPhotoUrl = photoUrl;
    if (userPhotoUrl == null) {
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
                backgroundImage: NetworkImage(userPhotoUrl),
                radius: 60,
                backgroundColor: Colors.white),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        // appBar: appBarDefault,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              stretch: false,
              leading: Container(),
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [card(context)],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(35.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget card(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    Center(
                      child: RichText(
                          text: TextSpan(
                        children: [
                          TextSpan(
                              text: "Welcome",
                              style: TextStyle(
                                  color: Colors.grey[900], fontSize: 20)),
                          TextSpan(text: " $name"),
                        ],
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      )),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      thickness: 2.0,
                      color: Colors.grey[900],
                    ),
                    SizedBox(height: 10),
                    /////////////////////////////////
                    checkProfilePhotoUrl(photoUrl),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                        ),
                        Text('Email :',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Text('$email',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            auth.logout(context);
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [tertiary, tertiary]),
                                borderRadius: BorderRadius.circular(40.0),
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
                                  child: Text('LOGOUT',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(
                thickness: 2.0,
                color: Colors.grey[900],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
