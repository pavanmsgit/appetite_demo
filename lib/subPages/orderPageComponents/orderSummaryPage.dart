import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/dataModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appetite_demo/mainScreens/login.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderSummaryPage extends StatefulWidget {
  OrderSummaryPage({@required this.orderId, @required this.dataOrder});
  final String orderId;
  final DocumentSnapshot dataOrder;

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  List<String> data;
  String uid, name, email, photoUrl;

  Future<void> _launched;


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

  Future<void> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  Stream _getStream() {
    var qs = FirebaseFirestore.instance
        .collection("order_items")
        .where('order_id', isEqualTo: widget.orderId)
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



  checkPayment(check){
    if(check==0){
      return Padding(
        padding: EdgeInsets.only(
            left: 0.0, right: 20.0, top: 5),
        child: Text(
          'Pay On Pick-Up',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: tertiary),
        ),
      );
    }else{
      return Padding(
        padding: EdgeInsets.only(
            left: 0.0, right: 20.0, top: 5),
        child: Text(
          'UPI / DEBIT CARD',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: tertiary),
        ),
      );
    }
  }


  checkPhoneNumber(orderPickUpMode,order){
    if(orderPickUpMode==1){
      return  Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 40.0, right: 20.0, top: 5),
                child: Text(
                  'Order By',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 40.0, right: 20.0, top: 5),
                child: Text(
                  order.order_by_name,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: tertiary),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 40.0, right: 20.0, top: 5),
                child: Text(
                  'Phone Number',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 40.0, right: 20.0, top: 5),
                child: Text(
                  order.order_by_phone,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: tertiary),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 40.0, right: 20.0, top: 5),
                child: Text(
                  'Friend Name',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 40.0, right: 20.0, top: 5),
                child: Text(
                  order.friend_name,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: tertiary),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 40.0, right: 20.0, top: 5),
                child: Text(
                  'Friend Phone Number',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ),
            ],
          ),
          Row(children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 40.0, right: 20.0, top: 5),
              child: Text(
                order.friend_number,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: tertiary),
              ),
            ),
          ],)

        ],
      );
    }
    else if(orderPickUpMode==0){
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 40.0, right: 20.0, top: 5),
                child: Text(
                  'Order By',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 40.0, right: 20.0, top: 5),
                child: Text(
                  order.order_by_name,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: tertiary),
                ),
              ),
            ],
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 40.0, right: 20.0, top: 5),
                child: Text(
                  'Phone Number',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 40.0, right: 20.0, top: 5),
                child: Text(
                  order.order_by_phone,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: tertiary),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
  

  @override
  Widget build(BuildContext context) {




    checkVegOrNonVeg(type) {
      if (type == 1) {
        return Container(
          child: Icon(
            Icons.recommend,
            color: Colors.green,
            size: 20,
          ),
        );
      } else if (type == 2) {
        return Container(
          child: Icon(
            Icons.recommend,
            color: Colors.red,
            size: 20,
          ),
        );
      } else {
        return Container();
      }
    }

    Size size = MediaQuery.of(context).size;
    final order = Orders.fromSnapshot(widget.dataOrder);

    var totalPrice = double.parse(order.order_total_price);

    print('TOTAL PRICE FROM DB: ${order.order_total_price}');

    double check = totalPrice * 0.18;
    double withoutGst =  totalPrice;
    double gst = check;
    double withGst = withoutGst + gst;


    int orderDate = order.order_timestamp.millisecondsSinceEpoch;
    final orderDateFormat = DateFormat('dd-MM-yyyy hh:mm a');
    String finalOrderDate =
    orderDateFormat.format(DateTime.fromMillisecondsSinceEpoch(orderDate));
    


    return SafeArea(
      child: Scaffold(
        //appBar: appBarDefault,
        body: StreamBuilder<QuerySnapshot>(
            stream: _getStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(
                  slivers: <Widget>[
                   sliverAppBarDefaultWithBackButton(size, context),

                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40.0, right: 0.0, top: 20),
                                child: Text(
                                  'Order Summary !',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: tertiary),
                                ),
                              ),
                            ],
                          ),

                          ///SHOP INFO LIST TILE
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20, top: 20),
                                child: ListTile(
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
                                        padding:
                                        EdgeInsets.only(top: 0.0, bottom: 5.0),
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
                                        padding: EdgeInsets.only(
                                            left: 5.0, right: 0.0, top: 5),
                                        child: Text(
                                          '${order.order_shop_overall_rating} ',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 0.0, right: 5.0, top: 5),
                                          child: Icon(
                                            Icons.star,
                                            size: 14,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 40.0, right: 0.0, top: 5,bottom: 10),
                                    child: Text(
                                      'Order status : ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.0, right: 0.0, top: 5,bottom: 10),
                                    child: getOrderStatus(order.order_status)
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                              thickness: 0.2,
                              color: tertiary
                          ),

                          ///ORDER ITEMS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40.0, right: 0.0, top: 5),
                                child: Text(
                                  'Your Order',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),


                        ],
                      ),
                    ),

                    ///LIST OF ITEMS
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          final orderItems = OrderItems.fromSnapshot(data);
                          return Container(
                            margin: EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: ListTile(
                              leading: Container(
                                height: 100,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    orderItems.item_photo,
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
                                    padding:
                                        EdgeInsets.only(top: 0.0, bottom: 5.0),
                                    child: Text(
                                      orderItems.item_name,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    'Rs.',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    '${orderItems.item_price}',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 0.0, bottom: 0.0, left: 5),
                                      child: checkVegOrNonVeg(
                                          orderItems.item_type)),
                                ],
                              ),
                              trailing: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  'x ${orderItems.item_quantity}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: snapshot.data.docs.length,
                      ),
                    ),

                    ///ITEM TOTAL
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Divider(
                              thickness: 0.2,
                              color: tertiary
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40.0, right: 20.0, top: 15),
                                child: Text(
                                  'ITEM TOTAL',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 0.0, right: 40.0, top: 15),
                                child: Text(
                                  'Rs. ${withoutGst}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40.0, right: 20.0, top: 10),
                                child: Text(
                                  'GST & Other Taxes',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 0.0, right: 40.0, top: 15),
                                child: Text(
                                  'Rs. ${gst}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                              thickness: 0.2,
                              color: tertiary
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40.0, right: 20.0, top: 5),
                                child: Text(
                                  'TOTAL AMOUNT',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 0.0, right: 40.0, top: 5),
                                child: Text(
                                  'Rs. ${withGst}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                              thickness: 0.2,
                              color: tertiary
                          ),
                        ],
                      ),
                    ),



                    ///BILLING INFO
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40.0, right: 20.0, top: 50),
                                child: Text(
                                  'ORDER DETAILS',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                              thickness: 0.1,
                              color: tertiary
                          ),

                          ///ORDER NUMBER
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40.0, right: 20.0, top: 5),
                                child: Text(
                                  'Order ID',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40.0, right: 20.0, top: 5),
                                child: Text(
                                  order.order_id,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: tertiary),
                                ),
                              ),
                            ],
                          ),

                          ///PAYMENT MODE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40.0, right: 20.0, top: 5),
                                child: Text(
                                  'Payment Mode',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40.0, right: 20.0, top: 0),
                                child: checkPayment(order.order_payment_mode),
                              ),
                            ],
                          ),


                          ///DATE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40.0, right: 20.0, top: 5),
                                child: Text(
                                  'Date',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40.0, right: 20.0, top: 5),
                                child: Text(
                                  finalOrderDate,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: tertiary),
                                ),
                              ),
                            ],
                          ),

                          ///PHONE NUMBER
                          checkPhoneNumber(order.order_pickup_mode,order)

                        ],
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

        extendBody: true,
        bottomNavigationBar:  Padding(
          padding: EdgeInsets.only(bottom: 20, left: 10),
          child: FloatingActionButton(
            backgroundColor: secondary,
            onPressed: () {
              if(order.friend_number==null){
                EasyLoading.showInfo('Can not call');
              }else{
                _launched = makePhoneCall('tel:${order.friend_number}');
              }
            },
            child: Icon(
              Icons.phone,
              color: tertiary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget orderItemList(context, data, size) {
    final order = Orders.fromSnapshot(widget.dataOrder);
    final orderItems = OrderItems.fromSnapshot(data);

    int orderDate = order.order_timestamp.millisecondsSinceEpoch;
    final orderDateFormat = DateFormat('dd-MM-yyyy hh:mm a');
    String finalOrderDate =
        orderDateFormat.format(DateTime.fromMillisecondsSinceEpoch(orderDate));

    return GestureDetector(
      onTap: () async {
        changeScreenFadeTransition(widget);
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
                ///ITEMS LIST
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

                ///ORDERED ON DATE
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

                ///TOTAL AMOUNT
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

                ///ORDER STATUS
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


