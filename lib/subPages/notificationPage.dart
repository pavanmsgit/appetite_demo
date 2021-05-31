import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/dataModels.dart';
import 'package:appetite_demo/subPages/orderPageComponents/orderSummaryPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appetite_demo/mainScreens/login.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({this.indexButton});
  final int indexButton;

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {

  TabController _tabController;

  final List<String> _tabs = ["TODAY'S", 'ALL NOTIFICATIONS',];

  //INTIALIZE PAGE WITH USER DATA
  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    getUserData();
    super.initState();
  }
  List<String> data;
  String uid, name, email, photoUrl, phone,token;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
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
    token = data[5];
  }








  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver:SliverAppBar(
                  floating: true,
                  stretch: true,
                  toolbarHeight: 50,
                  leading: Container(
                    child: IconButton(icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.white,size: 30,),onPressed: () {
                      Navigator.pop(context);
                    },),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      margin: EdgeInsets.only(bottom: 50),
                      height: 60,
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
                              padding: EdgeInsets.symmetric(horizontal: 10),
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
                              child: Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: Center(
                                  child: Image.asset(
                                    "assets/logo2.png",
                                    width: 100,
                                    height: 50,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),),
                          ),
                        ],
                      ),
                    ),
                  ),
                  expandedHeight: 160.0,
                  collapsedHeight: 50,
                  backgroundColor: Colors.transparent,
                  pinned: true,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(10),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 0),
                        margin: EdgeInsets.only(top: 0),
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                TabBar(
                                  controller: _tabController,
                                  indicatorColor: secondary,
                                  isScrollable: true,
                                  labelStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  labelColor: secondary,
                                  unselectedLabelColor:
                                  Colors.grey[500],
                                  mouseCursor: SystemMouseCursors.none,
                                  onTap: (tab) {
                                    print(
                                        'THIS IS TAB BAR INDEX ${_tabController.index}');
                                  },
                                  tabs: [
                                    Tab(
                                      text: "TODAY'S",
                                    ),
                                    Tab(
                                      text: "ALL NOTIFICATIONS",
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              for (final tab in _tabs)
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: _buildTabContent(tab, size),
                ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTabContent(tab, size) {
    if(tab == "TODAY'S"){
      DateTime today = DateTime.now();
      DateTime aDayAgo = today.subtract(const Duration(days: 1));

      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("notifications")
              .where('order_by_uid', isEqualTo: uid)
              .where('order_timestamp' ,isGreaterThan: aDayAgo)
              .orderBy('order_timestamp',descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: <Widget>[

                  SliverPadding(
                    padding: EdgeInsets.only(top: 30),
                  ),

                  ///LIST OF ITEMS
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        DocumentSnapshot data = snapshot.data.docs[index];
                        return notificationItemList(context, data, size);
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
            return Center(
              child: LoadingBouncingLine.square(
                size: 60.0,
                backgroundColor: tertiary,
                borderColor: tertiary,
                duration: Duration(milliseconds: 500),
              ),
            );
          });
    }
    else
    if(tab == "ALL NOTIFICATIONS"){
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("notifications")
              .where('order_by_uid', isEqualTo: uid)
              .orderBy('order_timestamp',descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: <Widget>[


                  SliverPadding(
                    padding: EdgeInsets.only(top: 30),
                  ),

                  ///LIST OF ITEMS
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        DocumentSnapshot data = snapshot.data.docs[index];
                        return notificationItemList(context, data, size);
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
            return Center(
              child: LoadingBouncingLine.square(
                size: 60.0,
                backgroundColor: tertiary,
                borderColor: tertiary,
                duration: Duration(milliseconds: 500),
              ),
            );
          });
    }
  }

  getOrderStatus(status) {
    if (status == 0) {
      return Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
            child: Text(
              'PENDING',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
              child: Icon(
                Icons.new_releases_rounded,
                size: 20,
                color: secondary,
              )),
        ],
      );
    }
    else if (status == 1) {
      return Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
            child: Text(
              'ACCEPTED',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Padding(
              padding:
              EdgeInsets.only(left: 5.0, right: 0.0, top: 0, bottom: 3),
              child: Icon(
                Icons.thumb_up_alt_rounded,
                size: 20,
                color: Colors.amber,
              )),
        ],
      );
    } else if (status == 2) {
      return Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
            child: Text(
              'COMPLETED ',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
              child: Icon(
                Icons.check_circle,
                size: 20,
                color: Colors.green,
              )),
        ],
      );
    }else if (status == 3) {
      return Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
            child: Text(
              'REJECTED ',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
              child: Icon(
                Icons.cancel,
                size: 20,
                color: Colors.red,
              )),
        ],
      );
    }
    else if (status == 4) {
      return Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
            child: Text(
              'READY FOR PICKUP ',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
              child: Icon(
                Icons.location_on_rounded,
                size: 20,
                color: secondary,
              )),
        ],
      );
    } else {
      return Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
            child: Text(
              'STATUS UNKNOWN ',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
              child: Icon(
                Icons.error,
                size: 20,
                color: Colors.red,
              )),
        ],
      );
    }
  }


  getAppBar(size,context){
    if(widget.indexButton==1){
      return sliverAppBarDefaultWithBackButtonDown(size,context);
    }else{
      return sliverAppBarDefault(size);
    }
  }



  Widget notificationItemList(context, data, size) {
    final notification = Notifications.fromSnapshot(data);

    int orderDate = notification.order_timestamp.millisecondsSinceEpoch;
    final orderDateFormat = DateFormat('dd-MM-yyyy hh:mm a');
    String finalOrderDate =
    orderDateFormat.format(DateTime.fromMillisecondsSinceEpoch(orderDate));

    return GestureDetector(
      onTap: () async {
        Navigator.of(context).push(
          changeScreenSide(
            OrderSummaryPage(orderId: notification.order_id, dataOrder: data),
          ),
        );
      },
      child: Container(
        //height: 110,
        margin: EdgeInsets.only(left: 5, right: 5),
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 2.0,
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    height: 100,
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Icon(Icons.notifications_rounded,color: tertiary,size: 50,),
                    ),
                  ),
                  title: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 3),
                        child: Text(
                          '${notification.description} ',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.only(left: 0.0, right: 0.0, top: 5,bottom: 5),
                      child: Text(
                        'OTP:',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(left: 2.0, right: 0.0, top: 5,bottom: 5),
                      child: Text(
                        '${notification.order_otp} ',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                    ),


                    Padding(
                      padding:
                      EdgeInsets.only(left: 20.0, right: 0.0, top: 5,bottom: 5),
                      child: Text(
                        'DATE:',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(left: 2.0, right: 0.0, top: 5,bottom: 5),
                      child: Text(
                        '$finalOrderDate',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                    ),

                  ],
                ),
              ],
            )),
      ),
    );
  }
}



/*  return SafeArea(
      child: Scaffold(
        //appBar: appBarDefault,
        body: StreamBuilder<QuerySnapshot>(
            stream: _getStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(
                  slivers: <Widget>[
                    getAppBar(size, context),

                    SliverToBoxAdapter(
                      child: Padding(padding: EdgeInsets.only(top: 10,bottom: 10),
                        child: Center(child: Text('YOUR ORDERS',style: TextStyle(fontSize: 15,color: Colors.grey,fontWeight: FontWeight.bold),),),),
                    ),

                    ///LIST OF ITEMS
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          return orderItemList(context, data, size);
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

        // resizeToAvoidBottomInset: false,
      ),
    );*/