import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/sharedPreferences.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/shopModel.dart';
import 'package:appetite_demo/subPages/homePageComponents/shopDetailsAndMenu.dart';
import 'package:appetite_demo/subPages/homePageComponents/shopListItemComponent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  String searchTag = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> searchListData = [''];

  @override
  void initState() {
    //getListOfSearchHistory();
    super.initState();
  }

  getListOfSearchHistory() async {
    searchListData = await getListData('searchList') ??
        setListData('searchList', searchListData);
    print('INIT METHOD');
    print(searchListData);
  }

  Stream _getStream() {
    var qs = FirebaseFirestore.instance
        .collection("shops")
        .where('shop_name_search', arrayContains: searchController.text)
        .snapshots();
    print('${qs.single}');
    return qs;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: StreamBuilder<QuerySnapshot>(
            stream: (searchTag != "" && searchTag != null)
                ? FirebaseFirestore.instance
                    .collection("shops")
                    .where('shop_name_search', arrayContains: searchTag)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection("shops")
                   // .where('shop_name_search', arrayContains: searchController.text)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(
                  slivers: <Widget>[
                    ///APP BAR IS UNIQUE HERE
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
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.only(
                                      right: 125,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 25),
                                          child: AnimSearchBar(
                                            animationDurationInMilli: 500,
                                            prefixIcon: Icon(
                                              Icons.search,
                                              color: tertiary,
                                              size: 25,
                                              semanticLabel: 'Tap to Search',
                                            ),
                                            autoFocus: true,
                                            width: 350,
                                            helpText: 'search ...',
                                            style: TextStyle(
                                                fontSize: 16, color: tertiary),
                                            textController: searchController,
                                            suffixIcon: Icon(
                                              Icons.search,
                                              color: secondary,
                                              size: 25,
                                              semanticLabel: 'Tap to Search',
                                            ),
                                            closeSearchOnSuffixTap: true,
                                            onSuffixTap: () {
                                              setState(() {
                                                searchTag =
                                                    searchController.text;

                                                //searchListData.add(searchTag);
                                                //setListData('searchList', searchListData);

                                                searchController.clear();
                                              });
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 50),
                                          child: Center(
                                            child: Image.asset(
                                              "assets/logo2.png",
                                              width: 100,
                                              height: 50,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      expandedHeight: 120,
                      backgroundColor: Colors.transparent,
                    ),

                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          final shop = Shop.fromSnapshot(data);
                          List<dynamic> list = shop.shop_cuisine;
                          print(list.join(" | "));
                          String concatenated = list.join(" | ");

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: (){
                                Navigator.of(context)
                                    .push(changeScreenSide(ShopDetailsAndMenu(
                                  data: data,
                                  size: size,
                                )));
                              },
                              leading: Container(
                                height: 100,
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    shop.shop_logo,
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
                                    padding:
                                        EdgeInsets.only(top: 0.0, bottom: 5.0),
                                    child: Text(
                                      shop.shop_name,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 0.0, right: 0.0, top: 5),
                                      child: Text(
                                        '${shop.shop_overall_rating} ',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 0.0, right: 5.0, top: 5),
                                        child: Icon(
                                          Icons.star,
                                          size: 13,
                                        )),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 0.0, right: 0.0, top: 5),
                                      child: Text(
                                        concatenated,
                                        style: TextStyle(fontSize: 11),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: snapshot.data.docs.length,
                      ),
                    ),
                  ],
                );
              }
              return LoadingPage();
            }),
      ),
    );
  }
}

/*SliverAppBar(
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

                        Positioned(
                          top: 50,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            child: AnimSearchBar(
                              autoFocus: true,
                              width: 400,
                              helpText: 'search for nearest restaurants',
                              style: TextStyle(
                                fontSize: 14,
                                color: tertiary
                              ),
                              textController: searchController,
                              onSuffixTap: () {
                                setState(() {
                                  searchController.clear();
                                });
                              },
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  expandedHeight: 120,
                  backgroundColor: Colors.transparent,
                ),*/
