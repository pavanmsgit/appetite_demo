import 'dart:async';
import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/models/shopModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:location/location.dart';

class MapsPage extends StatefulWidget {
  MapsPage({@required this.userCustomModelFromPreviousDataFetch});
  final userCustomModelFromPreviousDataFetch;

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  List<String> data;
  String uid, name, email, photoUrl, phone;

  var lat, lng;

  bool isLoading = true;

  var userModelCustom;

  //INITIALIZE PAGE WITH USER DATA
  @override
  void initState() {
    getUserData();
    userModelCustom = widget.userCustomModelFromPreviousDataFetch;
    getUserLocation();
    markers = Set.from([]);
    Location location = new Location();
    location.getLocation().then((res) {
      setState(() {
        lat = res.latitude;
        lng = res.longitude;
      });
      print('$lat $lng LAT AND LNG CHECK');
    });
    super.initState();
  }

  GoogleMapController mapController;

  BitmapDescriptor customMapMarker;
  BitmapDescriptor userCustomMapMarker;
  BitmapDescriptor boyCustomMapMarker;
  BitmapDescriptor girlCustomMapMarker;

  Set<Marker> markers;
  GoogleMapController _mapController;

  Future<LatLng> getUserLocation() async {
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
                snippet: 'Phone: ${model.phone}'
            ),
            onTap: () {
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
                snippet: 'Phone: ${model.phone}'
            ),

            onTap: () {
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
                snippet: 'Phone: ${model.phone}'
            ),
            onTap: () {
             /* EasyLoading.showToast(
                  "Name : ${model.name} \n College : ${model.collegeName} \n Phone : ${model.phone}",
                  maskType: EasyLoadingMaskType.black,
                  dismissOnTap: true,
                  toastPosition: EasyLoadingToastPosition.center);*/

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
                snippet: 'Phone: ${model.phone}'
            ),
            onTap: () {
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
                            Icons.keyboard_arrow_down_outlined,
                            color: Colors.white,
                            size: 30,
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

///PREVIOUS CODE
///
///
///
/*import 'dart:async';

import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/mainScreens/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  List<String> data;
  String uid, name, email, photoUrl, phone;

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
    phone = data[4];
  }



  /* Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }*/

  final controller = MapController(
    location: LatLng(12.925803532978822, 77.54612152937699),
  );

  void _gotoDefault() {
    controller.center = LatLng(12.642748303085364, 77.43987996749236);
  }

  void _onDoubleTap() {
    controller.zoom += 0.5;
  }

  Offset _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
    }
  }

  /*Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);


  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
*/


  Stream _getStream() {
    var qs = FirebaseFirestore.instance
        .collection("orders")
        //.where('order_by_uid', isEqualTo: uid)
        .snapshots();
    print('${qs.single}');
    return qs;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: _getStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        sliver: sliverAppBarDefaultWithBackButtonDown(size, context)
                      ),
                    ];
                  },
                 body:  GestureDetector(
                   onDoubleTap: _onDoubleTap,
                   onScaleStart: _onScaleStart,
                   onScaleUpdate: _onScaleUpdate,
                   onScaleEnd: (details) {
                     print(
                         "Location: ${controller.center.latitude}, ${controller.center.longitude}");
                   },
                   child: Stack(
                     children: [
                       Map(
                         controller: controller,
                         builder: (context, x, y, z) {
                           final url =
                               'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                           return Image.network(
                             url,
                             fit: BoxFit.cover,
                           );
                         },
                       ),
                       Center(
                         child: Icon(Icons.person_pin_circle_rounded, color: tertiary, size: 50,),
                       ),
                     ],
                   ),
                 ),
                );
              }

              return LoadingPage();
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: tertiary,
          onPressed: _gotoDefault,
          tooltip: 'My Location',
          child: Icon(Icons.my_location),
        ),
        // resizeToAvoidBottomInset: false,
      ),
    );
  }


}




*/
