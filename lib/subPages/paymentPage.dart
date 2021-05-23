import 'dart:math';

import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/mainScreens/homeMain.dart';
import 'package:appetite_demo/models/dataModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';



class PaymentPage extends StatefulWidget {
  PaymentPage({this.userCustomModelFromPreviousDataFetch,@required this.orderList,@required this.size
    ,@required this.finalPrice,@required this.totalItems,@required this.shop,@required this.pickUpMode});
  final UserModelCustom userCustomModelFromPreviousDataFetch;
  final List<OrderModel> orderList;
  final Size size;
  final String finalPrice;
  final int totalItems;
  var shop;
  final int pickUpMode;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  bool isLoading = false;

  List<String> data;
  String uid, name, email, photoUrl, phone;

  Razorpay _razorpay;
  var options;


  var rand = new Random();

  String finalOrderId ;

  int paymentMode = 0;

  //INTIALIZE PAGE WITH USER DATA
  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    getUserData();
    super.initState();
  }



  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }


  void openCheckout() async {
   finalOrderId = rand.nextInt(100000).toString() +
        rand.nextInt(10000).toString() +
        rand.nextInt(1000000).toString();

   double checkPrice = double.parse(widget.finalPrice) * 100;
   print(checkPrice);

    setState(() {
       options = {
        'key': 'rzp_test_Vajz6ZhkAekOt9',
        'amount': checkPrice,
        'name': name,
        'description': 'ORDER ID $finalOrderId',
        'prefill': {'contact': phone, 'email': email},
        'external': {
          'wallets': ['paytm','tez','phonepe']
        }
      };
    });

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('$e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async{
    finalOrderId = rand.nextInt(100000).toString() +
        rand.nextInt(10000).toString() +
        rand.nextInt(1000000).toString();

    if(widget.pickUpMode==0){
      FirebaseFirestore.instance.collection('orders').add({
        'order_id' : finalOrderId,
        'order_shop_id' : widget.shop.shop_id,
        'order_shop_name' : widget.shop.shop_name,
        'order_shop_logo' : widget.shop.shop_logo,
        'order_shop_overall_rating' : widget.shop.shop_overall_rating,
        'order_shop_location' : widget.shop.shop_location,
        'order_by_name' : name,
        'order_by_uid' : uid,
        'order_by_phone' : phone,
        'order_total_price' : widget.finalPrice,
        'order_total_quantity' : widget.totalItems,
        'order_payment_mode' : 1,
        'order_payment_id' : response.paymentId,
        'order_pickup_mode' : widget.pickUpMode,
        'order_status' : 0,
        'order_timestamp' : DateTime.now(),
        'order_payment_status': 1
      });
      for (var orderItems in widget.orderList) {
        FirebaseFirestore.instance.collection('order_items').add({
          'order_id': finalOrderId,
          'item_quantity': orderItems.quantity,
          'item_name': orderItems.shopItems.item_name,
          'item_price': orderItems.shopItems.item_price,
          'item_photo': orderItems.shopItems.item_photo,
          'item_type': orderItems.shopItems.item_type,
        });
      }
      EasyLoading.showSuccess('Payment Successful.\nThank you for placing your order !');
      changeScreenReplacement(context, HomeMain());
    }else
      if(widget.pickUpMode==1){
      FirebaseFirestore.instance.collection('orders').add({
        'order_id' : finalOrderId,
        'order_shop_id' : widget.shop.shop_id,
        'order_shop_name' : widget.shop.shop_name,
        'order_shop_logo' : widget.shop.shop_logo,
        'order_shop_overall_rating' : widget.shop.shop_overall_rating,
        'order_shop_location' : widget.shop.shop_location,
        'order_by_name' : name,
        'order_by_uid' : uid,
        'order_by_phone' : phone,
        'friend_name': widget.userCustomModelFromPreviousDataFetch.name,
        'friend_number':widget.userCustomModelFromPreviousDataFetch.phone,
        'friend_college':widget.userCustomModelFromPreviousDataFetch.collegeName,
        'order_total_price' : widget.finalPrice,
        'order_total_quantity' : widget.totalItems,
        'order_payment_mode' : 1,
        'order_payment_id' : response.paymentId,
        'order_pickup_mode' : widget.pickUpMode,
        'order_status' : 0,
        'order_timestamp' : DateTime.now(),
        'order_payment_status': 1
      });
      for (var orderItems in widget.orderList) {
        FirebaseFirestore.instance.collection('order_items').add({
          'order_id': finalOrderId,
          'item_quantity': orderItems.quantity,
          'item_name': orderItems.shopItems.item_name,
          'item_price': orderItems.shopItems.item_price,
          'item_photo': orderItems.shopItems.item_photo,
          'item_type': orderItems.shopItems.item_type,
        });
      }
      EasyLoading.showSuccess('Payment Successful.\nThank you for placing your order !');
      changeScreenReplacement(context, HomeMain());
    }


  }

  void _handlePaymentError(PaymentFailureResponse response) {
    EasyLoading.showInfo('Please Retry Your Payment !');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    EasyLoading.showInfo('Wallet Name : ${response.walletName}');
  }

  //CHECKING USER DATA
  getUserData() async {
    data = await UserData().getUserData();
    UserData().getUserData().then((result) {
      setState(() => data = result);
    });
    print('DATA CHECK FROM SHARED PREFERENCES ${data[0]} ${data[1]} ${data[2]} ${data[3]} ${data[4]}');
    uid = data[0];
    name = data[1];
    email = data[2];
    photoUrl = data[3];
    phone = data[4];
  }

  checkVegOrNonVeg(type) {
    if (type == 0) {
      return Container(
        child: Icon(
          Icons.recommend,
          color: Colors.green,
          size: 20,
        ),
      );
    } else if (type == 1) {
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

  checkPickUpType(type) {
    if (type == 0) {
      return Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 0,top: 40,bottom: 10),
              child: Text(
                'PICK-UP DETAILS',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 0,top: 10),
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
                      padding: EdgeInsets.only(left: 0,top: 10),
                      child: Text(
                        '$name',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 0,top: 10),
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
                      padding: EdgeInsets.only(left: 0,top: 10),
                      child: Text(
                        '$phone',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
              ],
            ),
          ),


        ],
      );
    } else {
      return Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 0,top: 40,bottom: 10),
              child: Text(
                'PICK-UP DETAILS',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 0,top: 10),
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
                      padding: EdgeInsets.only(left: 0,top: 10),
                      child: Text(
                        '${widget.userCustomModelFromPreviousDataFetch.name}',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 0,top: 10),
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
                      padding: EdgeInsets.only(left: 0,top: 10),
                      child: Text(
                        '${widget.userCustomModelFromPreviousDataFetch.phone}',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 0,top: 10),
                      child: Text(
                        'COLLEGE : ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
                Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 0,top: 10),
                      child: Text(
                        '${widget.userCustomModelFromPreviousDataFetch.collegeName}',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
              ],
            ),
          ),


        ],
      );



      /*return Column(
        children: [

          ElevatedButton(
            onPressed: () async {

            if (await FlutterContacts.requestPermission()) {

              var contact = await _contactPicker.selectContact();
              setState(() {

               // _contact = contact;
              });

              print(contact.fullName);

            }


          },
          child: Text('PICK CONTACTS'),
          ),

          *//*Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: TextField(
              controller: controllerName,
              keyboardType: TextInputType.name,
              cursorColor: Colors.black,
              autofocus: false,
              maxLength: 15,
              decoration: InputDecoration(
                hintText: "Your Friend's Name",
                hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                    color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
            child: TextField(
              controller: controllerNumber,
              keyboardType: TextInputType.number,
              cursorColor: Colors.black,
              autofocus: false,
              maxLines: 1,
              maxLength: 10,
              decoration: InputDecoration(
                hintMaxLines: 4,
                hintText: "Enter your friend's number : 98XXX XXXXX",
                hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                    color: Colors.grey),
              ),
            ),
          ),*//*
        ],
      );*/
    }
  }


  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      color: tertiary,
      progressIndicator: LoadingBumpingLine.square(
        size: 75.0,
        backgroundColor: tertiary,
        borderColor: tertiary,
        duration: Duration(milliseconds: 500),
      ),
      isLoading: isLoading,
      child: SafeArea(

        child: Scaffold(

          body: CustomScrollView(
            slivers: <Widget>[
              sliverAppBarDefaultWithBackButton(widget.size,context),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) => RadialGradient(
                          colors: [secondary, tertiary],
                          tileMode: TileMode.repeated)
                          .createShader(bounds),
                      child: Text(
                        "YOUR CART",
                        style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),

              ///LIST OF CART ITEMS
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    var order = widget.orderList[index];
                    return ListTile(
                      leading: Container(
                        height: 100,
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            order.shopItems.item_photo,
                            width: widget.size.width * 0.95,
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
                              order.shopItems.item_name,
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
                            '${order.shopItems.item_price}',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Padding(
                              padding:
                              EdgeInsets.only(top: 0.0, bottom: 0.0, left: 5),
                              child: checkVegOrNonVeg(order.shopItems.item_type)),
                        ],
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          'x ${order.quantity}',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    );
                  },
                  childCount: widget.orderList.length,
                ),
              ),

               SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: ToggleSwitch(
                      minWidth: widget.size.width * 0.7,
                      inactiveBgColor: Colors.white,
                      activeBgColor: Colors.black,
                      initialLabelIndex: paymentMode,
                      fontSize: 11,
                      cornerRadius: 20.0,
                      labels: ['PAY ON PICK-UP', 'UPI / DEBIT CARD'],
                      onToggle: (index) => setState(() => paymentMode = index)),
                ),
              ),



              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: checkPickUpType(widget.pickUpMode),
                ),
              ),





              SliverPadding(
                padding: EdgeInsets.all(80.0),
              ),
            ],
          ),

          // resizeToAvoidBottomInset: false,

          bottomNavigationBar: getBottomBadge(context, widget.size),
        ),
      ),
    );
  }



  getBottomBadge(context,size){
    if(paymentMode==0){
      return Padding(
        padding: EdgeInsets.all(12.0),
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          height: 60,
          width: double.infinity,
          child: ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Rs. ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.finalPrice,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      "Complete Order",
                      style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    )
                  ],
                ),
              ),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(1.0),
                foregroundColor: MaterialStateProperty.all<Color>(primary),
                backgroundColor: MaterialStateProperty.all<Color>(tertiary),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: tertiary),
                  ),
                ),
              ),
              onPressed: ()  async{


                 setState(() {
                  isLoading = true;
                });

                var rand = new Random();

                String finalNum = rand.nextInt(100000).toString() +
                    rand.nextInt(10000).toString() +
                    rand.nextInt(1000000).toString();



                 if(widget.pickUpMode==0){
                   FirebaseFirestore.instance.collection('orders').add({
                     'order_id' : finalNum,
                     'order_shop_id' : widget.shop.shop_id,
                     'order_shop_name' : widget.shop.shop_name,
                     'order_shop_logo' : widget.shop.shop_logo,
                     'order_shop_overall_rating' : widget.shop.shop_overall_rating,
                     'order_shop_location' : widget.shop.shop_location,
                     'order_by_name' : name,
                     'order_by_uid' : uid,
                     'order_by_phone' : phone,
                     'order_total_price' : widget.finalPrice,
                     'order_total_quantity' : widget.totalItems,
                     'order_payment_mode' : 0,
                     'order_pickup_mode' : widget.pickUpMode,
                     'order_status' : 0,
                     'order_timestamp' : DateTime.now(),
                     'order_payment_status': 0
                   });
                   for (var orderItems in widget.orderList) {
                     FirebaseFirestore.instance.collection('order_items').add({
                       'order_id': finalNum,
                       'item_quantity': orderItems.quantity,
                       'item_name': orderItems.shopItems.item_name,
                       'item_price': orderItems.shopItems.item_price,
                       'item_photo': orderItems.shopItems.item_photo,
                       'item_type': orderItems.shopItems.item_type,
                     });
                   }

                 }else
                 if(widget.pickUpMode==1){
                   FirebaseFirestore.instance.collection('orders').add({
                     'order_id' :finalNum,
                     'order_shop_id' : widget.shop.shop_id,
                     'order_shop_name' : widget.shop.shop_name,
                     'order_shop_logo' : widget.shop.shop_logo,
                     'order_shop_overall_rating' : widget.shop.shop_overall_rating,
                     'order_shop_location' : widget.shop.shop_location,
                     'order_by_name' : name,
                     'order_by_uid' : uid,
                     'order_by_phone' : phone,
                     'friend_name': widget.userCustomModelFromPreviousDataFetch.name,
                     'friend_number':widget.userCustomModelFromPreviousDataFetch.phone,
                     'friend_college':widget.userCustomModelFromPreviousDataFetch.collegeName,
                     'order_total_price' : widget.finalPrice,
                     'order_total_quantity' : widget.totalItems,
                     'order_payment_mode' : 0,
                     'order_pickup_mode' : widget.pickUpMode,
                     'order_status' : 0,
                     'order_timestamp' : DateTime.now(),
                     'order_payment_status': 0
                   });
                   for (var orderItems in widget.orderList) {
                     FirebaseFirestore.instance.collection('order_items').add({
                       'order_id': finalNum,
                       'item_quantity': orderItems.quantity,
                       'item_name': orderItems.shopItems.item_name,
                       'item_price': orderItems.shopItems.item_price,
                       'item_photo': orderItems.shopItems.item_photo,
                       'item_type': orderItems.shopItems.item_type,
                     });
                   }
                 }







                 EasyLoading.showSuccess('Payment Successful.\nThank you for placing your order !');
                    changeScreenReplacement(context, HomeMain());

              }
          ),
        ),
      );
    }else if(paymentMode==1){
      return Padding(
        padding: EdgeInsets.all(12.0),
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          height: 60,
          width: double.infinity,
          child: ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Rs. ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.finalPrice,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      "Make Payment and Complete >>",
                      style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                    )
                  ],
                ),
              ),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(1.0),
                foregroundColor: MaterialStateProperty.all<Color>(primary),
                backgroundColor: MaterialStateProperty.all<Color>(tertiary),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: tertiary),
                  ),
                ),
              ),
              onPressed: ()  async{
                openCheckout();
              }
          ),
        ),
      );
    }
  }


}
