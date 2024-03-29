import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/dataModels.dart';
import 'package:appetite_demo/subPages/addReview.dart';
import 'package:appetite_demo/subPages/cartPage.dart';
import 'package:appetite_demo/subPages/homePageComponents/cartBottomBadge.dart';
import 'package:appetite_demo/subPages/homePageComponents/foodCategories.dart';
import 'package:appetite_demo/subPages/homePageComponents/reviewsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appetite_demo/subPages/homePageComponents/addButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class ShopDetailsAndMenu extends StatefulWidget {
  ShopDetailsAndMenu({@required this.data, @required this.size});
  final DocumentSnapshot data;
  final Size size;

  @override
  _ShopDetailsAndMenuState createState() => _ShopDetailsAndMenuState();
}

class _ShopDetailsAndMenuState extends State<ShopDetailsAndMenu>
    with SingleTickerProviderStateMixin {
  bool _onlyVeg = false;
  bool _onlyNonVeg = false;
  bool _onlyDrinks = false;
  int orderQuantity = 0;
  ShopItems shopItems;

  List<ShopItems> shopItemsList;
  bool _shouldShowBottomCartBadge = false;
  String _totalPrice = "";
  int _totalQty = 0;

  @override
  void initState() {
    _counterValue = orderQuantity;
    super.initState();
  }

  bool _isActivated = false;
  int _counterValue = 0;

  List<OrderModel> orderList = [];

  void menuInteractedCallback(ShopItems shopItems, int quantity) {
    OrderModel order;
    orderList.removeWhere(
        (element) => element.shopItems.item_id == shopItems.item_id);
    if (quantity != 0) {
      order = OrderModel(shopItems, quantity);
      orderList.add(order);
    }
    setupBottomCartBadgeData(orderList);
  }

  void setupBottomCartBadgeData(List<OrderModel> orderList) {
    if (orderList.isEmpty) {
      setState(() {
        _shouldShowBottomCartBadge = false;
      });
      return;
    }

    int totalQty = 0;
    double totalPrice = 0.0;
    orderList.forEach((order) {
      totalQty = totalQty + order.quantity;
      totalPrice =
          totalPrice + order.quantity * int.parse(order.shopItems.item_price);
    });

    setState(() {
      _totalQty = totalQty;
      _totalPrice = totalPrice.toString();
      if (_totalQty > 0) {
        _shouldShowBottomCartBadge = true;
      }
    });
  }

  Stream _getStream() {
    if (_onlyVeg == true) {
      var qs = FirebaseFirestore.instance
          .collection("shops")
          .doc(widget.data.id)
          .collection('shop_items')
          .where('item_type', isEqualTo: 0)
          .snapshots();
      print('${qs.single}');
      return qs;
    } else if (_onlyNonVeg == true) {
      var qs = FirebaseFirestore.instance
          .collection("shops")
          .doc(widget.data.id)
          .collection('shop_items')
          .where('item_type', isEqualTo: 1)
          .snapshots();
      print('${qs.single}');
      return qs;
    } else if (_onlyDrinks == true) {
      var qs = FirebaseFirestore.instance
          .collection("shops")
          .doc(widget.data.id)
          .collection('shop_items')
          .where('item_type', isEqualTo: 2)
          .snapshots();
      print('${qs.single}');
      return qs;
    } else {
      var qs = FirebaseFirestore.instance
          .collection("shops")
          .doc(widget.data.id)
          .collection('shop_items')
          // .where('item_type', isEqualTo: 3)
          .snapshots();
      print('${qs.single}');
      return qs;
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = Shop.fromSnapshot(widget.data);

    List<dynamic> list = shop.shop_cuisine;
    print(list.join(" | "));
    String concatenated = list.join(" | ");

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
                      leading: Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      flexibleSpace: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        // It will cover 20% of our total height
                        height: widget.size.height * 0.6,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: widget.size.height * 0.30,
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
                              bottom: 230,
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
                            Positioned(
                              top: 110,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                //height: 90,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(70),
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                      shop.shop_logo,
                                      width: size.width * 0.95,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      //cancelToken: cancellationToken,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Make the initial height of the SliverAppBar larger than normal.
                      expandedHeight: 350,
                      backgroundColor: Colors.transparent,
                    ),

                    ///SHOP NAME AND INFO
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Text(
                            shop.shop_name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0, right: 0.0, top: 5),
                                child: Text(
                                  '${shop.shop_overall_rating} ',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.0, right: 5.0, top: 5),
                                  child: Icon(
                                    Icons.star,
                                    size: 12,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0, right: 0.0, top: 5),
                                child: Text(
                                  concatenated,
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    ///VEG OR NON VEG CHOICE CHIP
                    SliverToBoxAdapter(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10, top: 10),
                          child: ChoiceChip(
                            selectedColor: Colors.green,
                            labelStyle: TextStyle(
                                color:
                                    _onlyVeg == true ? Colors.white : tertiary),
                            label: Text("Veg"),
                            selected: _onlyVeg,
                            onSelected: (bool selected) {
                              setState(() {
                                _onlyVeg = !_onlyVeg;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10, top: 10),
                          child: ChoiceChip(
                            selectedColor: Colors.red,
                            labelStyle: TextStyle(
                                color: _onlyNonVeg == true
                                    ? Colors.white
                                    : tertiary),
                            label: Text("Non-Veg"),
                            selected: _onlyNonVeg,
                            onSelected: (bool selected) {
                              setState(() {
                                _onlyNonVeg = !_onlyNonVeg;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 30, top: 10),
                          child: ChoiceChip(
                            selectedColor: tertiary,
                            labelStyle: TextStyle(
                                color: _onlyDrinks == true
                                    ? Colors.white
                                    : tertiary),
                            label: Text("Drinks"),
                            selected: _onlyDrinks,
                            onSelected: (bool selected) {
                              setState(() {
                                _onlyDrinks = !_onlyDrinks;
                              });
                            },
                          ),
                        ),
                      ],
                    )),

                    ///LIST OF ITEMS
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          return itemList(context, data);
                        },
                        childCount: snapshot.data.docs.length,
                      ),
                    ),

                    SliverPadding(
                      padding: EdgeInsets.only(top: 20),
                    ),

                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20,horizontal: 80),
                        child: InkWell(
                          onTap: () async {
                            Navigator.of(context)
                                .push(changeScreenUp(AddReview(docId: shop.shop_id,ratings: shop.shop_overall_rating.truncateToDouble(),)));
                          },
                          child: Container(
                              width: 100,
                              height: 50,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [tertiary, tertiary]),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: tertiary.withOpacity(.3),
                                        offset: Offset(0.4, 0.4),
                                        blurRadius: 8.0)
                                  ]),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0,right: 20),
                                    child: Icon(
                                      Icons.rate_review_rounded,
                                      color: secondary,
                                      size: 30,
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      child: Center(
                                        child: Text('ADD REVIEW',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, top: 10, bottom: 15),
                        child: Text(
                          "Reviews from our customers !",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.only(left: 0,right: 20),
                      width: 150,
                      height: 150,
                      child: listOfReviews(context, shop.shop_id),
                    )),

                    SliverPadding(
                      padding: EdgeInsets.only(top: 50),
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
                      padding: EdgeInsets.only(bottom: 100),
                    ),
                  ],
                );
              }
              return LoadingPage();
            }),

        bottomSheet: Visibility(
          visible: _shouldShowBottomCartBadge,
          child: CartBottomBadge(
            itemCount: _totalQty,
            itemTotalPrice: _totalPrice,
            shouldShowPrice: true,
            onPress: () async {
              Navigator.of(context).push(changeScreenSide(CartPage(
                orderList: orderList,
                size: size,
                finalPrice: _totalPrice,
                shop: shop,
                totalItems: _totalQty,
              )));
            },
          ),
        ),
      ),
    );
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

  Widget itemList(BuildContext context, data) {
    final item = ShopItems.fromSnapshot(data);
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: ListTile(
        leading: Container(
          height: 100,
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.item_photo,
              width: size.width * 0.65,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0.0, bottom: 5.0),
              child: Text(
                item.item_name,
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
              '${item.item_price}',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
            ),
            Padding(
                padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 5),
                child: checkVegOrNonVeg(item.item_type)),
          ],
        ),
        trailing: AddButton(
            quantity: orderQuantity,
            onInteractedCallback: (quantity) {
              menuInteractedCallback(
                item,
                quantity,
              );
            }),
      ),
    );
  }
}

/*Column(
                        children: <Widget>[
                          Stack(
                            children: [
                              Container(
                                height: widget.size.height * 0.15,
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
                          Container(
                            child: Positioned(
                              top: 125,
                              bottom: 0,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                height: size.height / 4,
                                width: size.width * 0.90,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network(
                                    shop.shop_logo,
                                    width: size.width * 0.95,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    //cancelToken: cancellationToken,
                                  ),
                                ),
                              ),
                            ),
                          ),




                        ],
                      ),*/

///SHADER MASK EXAMPLE

/*SliverToBoxAdapter(
                      child: ShaderMask(
                        shaderCallback: (bounds) => RadialGradient(
                                colors: [secondary, secondary],
                                tileMode: TileMode.mirror)
                            .createShader(bounds),
                        child: Container(
                          height: size.height / 3,
                          width: size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                            ),
                            child: Image.network(
                              shop.shop_logo,
                              width: size.width * 0.95,
                              height: 200,
                              fit: BoxFit.fill,
                              //cancelToken: cancellationToken,
                            ),
                          ),
                        ),
                      ),
                    ),

                    ///LIST OF S*/
