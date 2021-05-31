import 'dart:async';
import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/dataModels.dart';
import 'package:appetite_demo/subPages/paymentPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:loading_overlay/loading_overlay.dart';
//import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';


class MapsForChoosingContact extends StatefulWidget {
  MapsForChoosingContact(
      {@required this.userCustomModelFromPreviousDataFetch,
      @required this.orderList,
      @required this.size,
      @required this.finalPrice,
      @required this.totalItems,
      @required this.shop});
  final userCustomModelFromPreviousDataFetch;
  final List<OrderModel> orderList;
  final Size size;
  final String finalPrice;
  final int totalItems;
  var shop;

  @override
  _MapsForChoosingContactState createState() => _MapsForChoosingContactState();
}

class _MapsForChoosingContactState extends State<MapsForChoosingContact> {
  List<String> data;
  String uid, name, email, photoUrl, phone,token;


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


  var lat,lng;
  //var lat=13.117436463163937, lng=77.6165259629488;

  bool isLoading = true;

  var userModelCustom;

  Future<void> _launched;


  Position _currentPosition;
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;

  //INITIALIZE PAGE WITH USER DATA
  @override
  void initState() {
    getUserData();
    userModelCustom = widget.userCustomModelFromPreviousDataFetch;
    addLocationLive();
    //getUserLocation();
    markers = Set.from([]);

    super.initState();
  }

  Future addLocationLive() async{
    geoLocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((position) {
      setState(() {
        _currentPosition = position;
        lat = position.latitude;
        lng = position.longitude;
      });
    });
  }

  GoogleMapController mapController;

  BitmapDescriptor customMapMarker;
  BitmapDescriptor userCustomMapMarker;
  BitmapDescriptor boyCustomMapMarker;
  BitmapDescriptor girlCustomMapMarker;

  UserModelCustom selectedUserDataModel;

  Set<Marker> markers;
  GoogleMapController _mapController;

  /*Future<LatLng> getUserLocation() async {
    LocationData locationFinal;
    Location location = new Location();

    try {
      locationFinal = await location.getLocation();

      final lat = locationFinal.latitude;

      final lng = locationFinal.longitude;

      final center = LatLng(lat, lng);

      return center;
    } on Exception {
      locationFinal = null;
      return null;
    }
  }*/

  Future<void> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  createMarker(context) {
    if (customMapMarker == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              configuration, "assets/othersMapPointer.png",
              mipmaps: true)
          .then((icon) {
        setState(() {
          customMapMarker = icon;
        });
      });
    }
  }

  createMarkerBoy(context) {
    if (boyCustomMapMarker == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, "assets/boyMapPointer.png",
              mipmaps: true)
          .then((icon) {
        setState(() {
          boyCustomMapMarker = icon;
        });
      });
    }
  }

  createMarkerGirl(context) {
    if (girlCustomMapMarker == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              configuration, "assets/girlMapPointer.png",
              mipmaps: true)
          .then((icon) {
        setState(() {
          girlCustomMapMarker = icon;
        });
      });
    }
  }

  createMarkerUser(context) {
    if (userCustomMapMarker == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, "assets/mapMarker.png",
              mipmaps: true)
          .then((icon) {
        setState(() {
          userCustomMapMarker = icon;
        });
      });
    }
  }

  void _onMapCreated(controller) {
    userModelCustom = widget.userCustomModelFromPreviousDataFetch;
    setState(() {
      for (UserModelCustom model in userModelCustom) {
        print('THIS IS ON MAP CREATED METHOD ${model.name}');
        print(model.location.latitude);

        Marker o = Marker(
            markerId: MarkerId('${UniqueKey()}'),
            icon: customMapMarker,
            position: LatLng(model.location.latitude, model.location.longitude),
            draggable: true,
            alpha: 0.9,
            infoWindow: InfoWindow(
                title: '${model.name}, ${model.collegeName}',
                snippet: 'Phone: ${model.phone}'),
            onTap: () {
              setState(() {
                selectedUserDataModel = model;
                print(
                    '${selectedUserDataModel.id} ${selectedUserDataModel.phone}');
              });
              EasyLoading.showToast(
                  "SELECTED \n Name : ${model.name} \n College : ${model.collegeName} \n Phone : ${model.phone}",
                  maskType: EasyLoadingMaskType.clear,
                  dismissOnTap: true,
                  toastPosition: EasyLoadingToastPosition.center);

              print('USER NAME ${model.name}');
              print('USER NUMBER ${model.phone}');
            });

        Marker k = Marker(
            markerId: MarkerId('${UniqueKey()}'),
            icon: userCustomMapMarker,
            position: LatLng(model.location.latitude, model.location.longitude),
            draggable: true,
            alpha: 0.9,
            infoWindow: InfoWindow(
                title: '${model.name}, ${model.collegeName}',
                snippet: 'Phone: ${model.phone}'),
            onTap: () {
              setState(() {
                selectedUserDataModel = model;
                print(
                    '${selectedUserDataModel.name} ${selectedUserDataModel.phone}');
              });
              EasyLoading.showToast(
                  "SELECTED \n Name : ${model.name} \n College : ${model.collegeName} \n Phone : ${model.phone}",
                  maskType: EasyLoadingMaskType.clear,
                  dismissOnTap: true,
                  toastPosition: EasyLoadingToastPosition.center);
              print('USER NAME ${model.name}');
              print('USER NUMBER ${model.phone}');
            });

        Marker g = Marker(
            markerId: MarkerId('${UniqueKey()}'),
            icon: girlCustomMapMarker,
            position: LatLng(model.location.latitude, model.location.longitude),
            draggable: true,
            alpha: 0.9,
            infoWindow: InfoWindow(
                title: '${model.name}, ${model.collegeName}',
                snippet: 'Phone: ${model.phone}'),
            onTap: () {
              setState(() {
                selectedUserDataModel = model;
                print(
                    '${selectedUserDataModel.name} ${selectedUserDataModel.phone}');
              });
              EasyLoading.showToast(
                  "SELECTED \n Name : ${model.name} \n College : ${model.collegeName} \n Phone : ${model.phone}",
                  maskType: EasyLoadingMaskType.clear,
                  dismissOnTap: true,
                  toastPosition: EasyLoadingToastPosition.center);

              print('USER NAME ${model.name}');
              print('USER NUMBER ${model.phone}');
            });

        Marker b = Marker(
            markerId: MarkerId('${UniqueKey()}'),
            icon: boyCustomMapMarker,
            position: LatLng(model.location.latitude, model.location.longitude),
            draggable: true,
            alpha: 0.9,
            infoWindow: InfoWindow(
                title: '${model.name}, ${model.collegeName}',
                snippet: 'Phone: ${model.phone}'),
            onTap: () {
              setState(() {
                selectedUserDataModel = model;
                print(
                    '${selectedUserDataModel.name} ${selectedUserDataModel.phone}');
              });
              EasyLoading.showToast(
                  "SELECTED \n Name : ${model.name} \n College : ${model.collegeName} \n Phone : ${model.phone}",
                  maskType: EasyLoadingMaskType.clear,
                  dismissOnTap: true,
                  toastPosition: EasyLoadingToastPosition.center);

              print('USER NAME ${model.name}');
              print('USER NUMBER ${model.phone}');
            });

        if (model.gender == 'BOY') {
          markers.add(b);
        } else if (model.gender == 'GIRL') {
          markers.add(g);
        } else {
          markers.add(o);
        }
      }
      isLoading = false;
      _mapController = controller;
    });
  }

  setUpBottomSheet(size) {
    if (selectedUserDataModel != null) {
      return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: tertiary,
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              padding: const EdgeInsets.symmetric(horizontal: 0),
              margin: EdgeInsets.only(bottom: 20),
              child: ListTile(
                tileColor: tertiary,
                onTap: () {},
                leading: Container(
                  height: 100,
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      selectedUserDataModel.photo,
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
                        selectedUserDataModel.name,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
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
                        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5),
                        child: Text(
                          '${selectedUserDataModel.phone} ',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5),
                        child: Text(
                          '|| ${selectedUserDataModel.collegeName} ',
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                trailing: IconButton(icon: Icon(Icons.phone,color: secondary,),onPressed: (){
                  if(selectedUserDataModel.phone ==null){
                    EasyLoading.showInfo('Can not call');
                  }else{
                    _launched = makePhoneCall('tel:${selectedUserDataModel.phone}');
                  }
                },
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Container(
                margin: EdgeInsets.only(bottom: 20, left: 10, right: 50),
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Proceed to Payment >>",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
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
                    onPressed: () async {
                      Navigator.of(context).push(changeScreenSide(PaymentPage(
                        userCustomModelFromPreviousDataFetch:
                            selectedUserDataModel,
                        orderList: widget.orderList,
                        size: widget.size,
                        finalPrice: widget.finalPrice,
                        shop: widget.shop,
                        totalItems: widget.totalItems,
                        pickUpMode: 1,
                      )));
                    }),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    createMarker(context);
    createMarkerUser(context);
    createMarkerBoy(context);
    createMarkerGirl(context);

    return LoadingOverlay(
      isLoading: isLoading,
      color: Colors.white,
      opacity: 1.0,
      progressIndicator: LoadingBouncingGrid.square(
        size: 60.0,
        //inverted: true,
        backgroundColor: tertiary,
        borderColor: tertiary,
        duration: Duration(milliseconds: 1000),
      ),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: NestedScrollView(
            physics: NeverScrollableScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    floating: false,
                    leading: Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    stretch: false,
                    pinned: true,
                    collapsedHeight: 120,
                    toolbarHeight: 120,
                    expandedHeight: 80,
                    backgroundColor: Colors.transparent,
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Container(
              height: size.height * 0.98,
              child: loadMaps(),
            ),
          ),
          bottomNavigationBar: setUpBottomSheet(size),
          extendBody: true,
        ),
      ),
    );
  }

  loadMaps() {
    if (lat != null) {
      return GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: _onMapCreated,
        mapType: MapType.normal,
        //onTap: addMarkers(usersLocation),
        markers: markers,
        initialCameraPosition:
            CameraPosition(target: LatLng(lat, lng), zoom: 10),
      );
    } else {
      return LoadingPage();
    }
  }
}
