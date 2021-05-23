import 'dart:math';
import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/main.dart';
import 'package:appetite_demo/mainScreens/homeMain.dart';
import 'package:appetite_demo/models/dataModels.dart';
import 'package:appetite_demo/subPages/mapsForChoosingContact.dart';
import 'package:appetite_demo/subPages/paymentPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
//import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:toggle_switch/toggle_switch.dart';

class CartPage extends StatefulWidget {
  CartPage(
      {@required this.orderList,
      @required this.size,
      @required this.finalPrice,
      @required this.shop,
        @required this.totalItems});
  final List<OrderModel> orderList;
  final Size size;
  final String finalPrice;
  final int totalItems;
  var shop;

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int pickUpMode = 0;
  //int paymentMode = 0;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerNumber = TextEditingController();
  TextEditingController controllerUserNumber = TextEditingController();


  final ContactPicker _contactPicker = new ContactPicker();
  //Contact _contact;

  int a;
  double totalPrice;
  bool isLoading = false;



  List<String> data;
  String uid, name, email, photoUrl, phone;

  List<UserModelCustom> list = [];

  //INTIALIZE PAGE WITH USER DATA
  @override
  void initState() {
    getUserData();
    fetchData();
    super.initState();
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


  Future<List<UserModelCustom>> fetchData() async {
    await FirebaseFirestore.instance.collection("users").get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        UserModelCustom userModelCustom = UserModelCustom(
            value.docs[i]['user_id'],
            value.docs[i]['user_name'],
            value.docs[i]['user_phone'],
            value.docs[i]['user_location'],
            value.docs[i]['user_gender'],
            value.docs[i]['user_college_name'],
            value.docs[i]['user_logo']);
        list.add(userModelCustom);
        //print('HEY $list');
      }
    });
    return list;
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
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

          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Text(
                'TO CHANGE PHONE NUMBER. PLEASE GO TO ACCOUNT SETTINGS.',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 8,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        child:  Center(
          child: Padding(
            padding: EdgeInsets.only(left: 0,top: 30),
            child: Text(
              'CLICK ON THE BUTTON BELOW TO ADD FRIEND DETAILS.',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
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

    //a = int.parse(widget.finalPrice.trim());

    var a = double.parse('${widget.finalPrice}');
    totalPrice = a + a * 0.18;


    return LoadingOverlay(
      color: tertiary,
      progressIndicator: LoadingBumpingLine.square(
        size: 75.0,
        backgroundColor: secondary,
        borderColor: secondary,
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
                      initialLabelIndex: pickUpMode,
                      fontSize: 11,
                      cornerRadius: 20.0,
                      labels: ['SELF PICK-UP', 'FRIEND PICK-UP'],
                      onToggle: (index) => setState(() => pickUpMode = index)),
                ),
              ),


              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: checkPickUpType(pickUpMode),
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

    if(pickUpMode==0){
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
                          '${totalPrice.truncate()}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      "Proceed to Payment >>",
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

                Navigator.of(context).push(changeScreenSide(PaymentPage(
                  orderList: widget.orderList,
                  size: widget.size,
                  finalPrice: totalPrice.truncate().toString(),
                  shop: widget.shop,
                  totalItems: widget.totalItems,
                  pickUpMode: 0,
                )));
              }
          ),
        ),
      );
    }else if(pickUpMode==1){
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
                          '${totalPrice.truncate()}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      "Continue to Choose Friend >>",
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

                fetchData().whenComplete(() {
                  print('CHECK LIST $list');
                  Navigator.of(context).push(changeScreenSide(MapsForChoosingContact(
                    userCustomModelFromPreviousDataFetch : list,
                    orderList: widget.orderList,
                    size: widget.size,
                    finalPrice: totalPrice.truncate().toString(),
                    shop: widget.shop,
                    totalItems: widget.totalItems,
                  )));
                });


                list.clear();

              }
          ),
        ),
      );
    }
  }
}







/* setState(() {
                  isLoading = true;
                });

                var rand = new Random();

                String finalNum = rand.nextInt(100000).toString() +
                    rand.nextInt(10000).toString() +
                    rand.nextInt(1000000).toString();


                ///TODO PAYMENT GATEWAY AND PAYMENT MODE IS 1
                if(paymentMode==1){
                  Fluttertoast.showToast(
                      msg: "Payment through UPI/DEBIT CARD in Development. For instance use pay on pick-up.",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: tertiary,
                      textColor: Colors.white,
                      fontSize: 12.0);
                } else if(pickUpMode==0){
                  if(controllerUserNumber.text.isEmpty){
                    Fluttertoast.showToast(
                        msg: "Please fill required fields",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: tertiary,
                        textColor: Colors.white,
                        fontSize: 12.0);
                  }else{
                    FirebaseFirestore.instance.collection('orders').add({
                      'order_id' : finalNum,
                      'order_shop_id' : widget.shop.shop_id,
                      'order_shop_name' : widget.shop.shop_name,
                      'order_shop_logo' : widget.shop.shop_logo,
                      'order_shop_overall_rating' : widget.shop.shop_overall_rating,
                      'order_shop_location' : widget.shop.shop_location,
                      'order_by_name' : name,
                      'order_by_uid' : uid,
                      'order_by_phone' : controllerUserNumber.text,
                      'order_total_price' : totalPrice.truncate().toString(),
                      'order_total_quantity' : widget.totalItems,
                      'order_payment_mode' : paymentMode,
                      'order_pickup_mode' : pickUpMode,
                      'order_status' : 0,
                      'order_timestamp' : DateTime.now()

                    });
                    for (var orderItems in widget.orderList) {FirebaseFirestore.instance.collection('order_items').add({
                      'order_id': finalNum,
                      'item_quantity' : orderItems.quantity,
                      'item_name' : orderItems.shopItems.item_name,
                      'item_price' : orderItems.shopItems.item_price,
                      'item_photo' : orderItems.shopItems.item_photo,
                      'item_type' : orderItems.shopItems.item_type,
                    });}
                    EasyLoading.showSuccess('Order Placed !');
                    changeScreenReplacement(context, HomeMain());
                  }

                }
                else if(pickUpMode==1){
                  if(controllerNumber.text.isEmpty || controllerName.text.isEmpty){

                    Fluttertoast.showToast(
                        msg: "Please fill required fields",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: tertiary,
                        textColor: Colors.white,
                        fontSize: 12.0);
                  }else{
                    FirebaseFirestore.instance.collection('orders').add({
                      'order_id' : finalNum,
                      'order_shop_id' : widget.shop.shop_id,
                      'order_shop_name' : widget.shop.shop_name,
                      'order_shop_logo' : widget.shop.shop_logo,
                      'order_shop_overall_rating' : widget.shop.shop_overall_rating,
                      'order_shop_location' : widget.shop.shop_location,
                      'order_by_name' : name,
                      'order_by_uid' : uid,
                      'order_total_price' : totalPrice.truncate().toString(),
                      'order_total_quantity' : widget.totalItems,
                      'order_payment_mode' : paymentMode,
                      'order_pickup_mode' : pickUpMode,
                      'order_status' : 0,
                      'friend_name' : controllerName.text,
                      'friend_number' : controllerNumber.text,
                      'order_timestamp' : DateTime.now()
                    });
                    for (var orderItems in widget.orderList) {FirebaseFirestore.instance.collection('order_items').add({'order_id': finalNum,
                      'item_quantity' : orderItems.quantity,
                      'item_name' : orderItems.shopItems.item_name,
                      'item_price' : orderItems.shopItems.item_price,
                      'item_photo' : orderItems.shopItems.item_photo,
                      'item_type' : orderItems.shopItems.item_type,
                    });}
                    EasyLoading.showSuccess('Order Placed !');
                    changeScreenReplacement(context, HomeMain());

                  }
                }*/