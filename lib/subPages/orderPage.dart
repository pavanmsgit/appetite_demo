import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/loadingPage.dart';
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
                    silverAppBarDefault(size),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(left: 35, top: 10, bottom: 10),
                        child: Text(
                          "Your Orders",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
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
              return LoadingPage();
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

