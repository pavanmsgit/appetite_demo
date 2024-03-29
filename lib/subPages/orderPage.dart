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
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderPage extends StatefulWidget {
  OrderPage({this.indexButton});
  final int indexButton;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with SingleTickerProviderStateMixin {

  TabController _tabController;

  final List<String> _tabs = ['YOUR ORDERS', 'FRIEND ORDERS',];

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

  Future<void> _launched;


  Future<void> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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


  Stream _getStream() {
    if(_tabController.index == 1){
      var qs = FirebaseFirestore.instance
          .collection("orders")
          .where('friend_uid', isEqualTo: uid)
         // .orderBy('order_timestamp',descending: true)
          .snapshots();
      print('${qs.single}');
      return qs;
    }else {
      var qs = FirebaseFirestore.instance
          .collection("orders")
          .where('order_by_uid', isEqualTo: uid)
          .orderBy('order_timestamp',descending: true)
          .snapshots();
      print('${qs.single}');
      return qs;
    }
  }


  getBackButton(){
    if(widget.indexButton == 1){
      return Container(
        child: IconButton(icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.white,size: 30,),onPressed: () {
          Navigator.pop(context);
        },),
      );
    }
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
                  leading: getBackButton(),
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
                                      text: 'MY ORDERS',
                                    ),
                                    Tab(
                                      text: 'FRIEND ORDERS',
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
    if(tab == 'YOUR ORDERS'){
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
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
      if(tab == 'FRIEND ORDERS'){
        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("orders")
                .where('friend_uid', isEqualTo: uid)
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



  getCallFriendButton(order){
    if(order.friend_number != null){
      return IconButton(icon:Icon(Icons.phone,color:tertiary),onPressed: (){
        if(order.friend_number==null){
          EasyLoading.showInfo('Can not call');
        }else{
          _launched = makePhoneCall('tel:${order.friend_number}');
        }
      },);
    }
  }

  Widget orderItemList(context, data, size) {
    final order = Orders.fromSnapshot(data);

    int orderDate = order.order_timestamp.millisecondsSinceEpoch;
    final orderDateFormat = DateFormat('dd-MM-yyyy hh:mm a');
    String finalOrderDate =
        orderDateFormat.format(DateTime.fromMillisecondsSinceEpoch(orderDate));

    return GestureDetector(
      onTap: () async {
        Navigator.of(context).push(
          changeScreenSide(
            OrderSummaryPage(orderId: order.order_id, dataOrder: data),
          ),
        );
      },
      child: Container(
        height: 280,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            elevation: 3.0,
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    height: 100,
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        order.order_shop_logo,
                        width: size.width * 0.95,
                        height: 100,
                        fit: BoxFit.cover,
                        //cancelToken: cancellationToken,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0.0, bottom: 5.0),
                        child: Text(
                          order.order_shop_name,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5.0, right: 0.0, top: 5),
                        child: Text(
                          '${order.order_shop_overall_rating} ',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 0.0, right: 5.0, top: 5),
                          child: Icon(
                            Icons.star,
                            size: 14,
                          )),
                    ],
                  ),
                  trailing: getCallFriendButton(order)
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding:
                          EdgeInsets.only(left: 20.0, right: 0.0, top: 5),
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
                          EdgeInsets.only(left: 2.0, right: 0.0, top: 5),
                          child: Text(
                            '${order.order_otp} ',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20.0, right: 0.0, top: 5),
                          child: Text(
                            'ITEMS',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20.0, right: 0.0, top: 5),
                          child: Text(
                            '${order.order_total_quantity} ',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 0.0, right: 0.0, top: 5),
                          child: Text(
                            'x Number Of Items ',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20.0, right: 0.0, top: 5),
                          child: Text(
                            'ORDERED ON',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20.0, right: 0.0, top: 5),
                          child: Text(
                            finalOrderDate,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20.0, right: 0.0, top: 5),
                          child: Text(
                            'TOTAL AMOUNT',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20.0, right: 0.0, top: 5),
                          child: Text(
                            order.order_total_price,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20.0, right: 0.0, top: 10),
                          child: Text(
                            'ORDER STATUS : ',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                          ),
                        ),
                        Padding(
                            padding:
                                EdgeInsets.only(left: 0.0, right: 0.0, top: 10),
                            child: getOrderStatus(order.order_status)),
                      ],
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