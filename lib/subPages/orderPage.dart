import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/shopModel.dart';
import 'package:appetite_demo/subPages/orderPageComponents/orderSummaryPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appetite_demo/mainScreens/login.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
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

  getOrderStatus(status) {
    if (status == 0) {
      return Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
            child: Text(
              'PENDING ',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0),
              child: Icon(
                Icons.pending,
                size: 20,
                color: secondary,
              )),
        ],
      );
    } else if (status == 1) {
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
                Icons.pin_drop,
                size: 20,
                color: tertiary,
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
              'DELIVERED ',
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
    } else {
      return Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 0.0, top: 10),
            child: Text(
              'STATUS UNKNOWN',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        //appBar: appBarDefault,
        body: StreamBuilder<QuerySnapshot>(
            stream: _getStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(
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
                      padding: EdgeInsets.all(35.0),
                    ),
                  ],
                );
              }
              return Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(secondary))
                  ],
                ),
              );
            }),

        // resizeToAvoidBottomInset: false,
      ),
    );
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
          changeScreenFadeTransition(
            OrderSummaryPage(orderId: order.order_id, dataOrder: data),
          ),
        );
      },
      child: Container(
        height: 250,
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
                        fit: BoxFit.fill,
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
                            '${order.order_total_price}',
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

/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ordered Items List",
          style: TextStyle(color: Colors.black, fontSize: 23.0),
        ),
        backgroundColor: Colors.white,
        elevation: 10.0,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        children: <Widget>[
          OrderCard(),
          OrderCard(),
          OrderCard(),
        ],
      ),
      bottomNavigationBar: orderDetail(),
    );
  }
*/

/*  Widget orderDetail() {
    return Container(
      height: 220.0,
      margin: EdgeInsets.only(top: 25.0, bottom: 16.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Card Total",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "\u20B9 33.0",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 13.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Discount",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "2.0",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 13.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Tax",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "3.0",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(
            height: 40.0,
            color: Color(0xFFD3D3D3),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Sub Total",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "38.0",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),

          // ListTile(
          //   leading: Text("Card Total",style: TextStyle(color: Colors.grey,fontSize: 16.0,fontWeight: FontWeight.bold),),
          //   trailing: Text("33.0",style: TextStyle(color: Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold),),
          // ),
          SizedBox(
            height: 24.0,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Login()));
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Center(
                child: Text(
                  "Procede to CheckOut",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }*/
