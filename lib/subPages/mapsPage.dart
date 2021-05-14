import 'dart:async';

import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/helpers/appBarDefault.dart';
import 'package:appetite_demo/helpers/loadingPage.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/mainScreens/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';
//import "package:latlong/latlong.dart" as latLng;



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
    _getCurrentLocation();
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


  GoogleMapController _mapController ;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }




  Stream _getStream() {
    var qs = FirebaseFirestore.instance
        .collection("users")
        //.where('order_by_uid', isEqualTo: uid)
        .snapshots();
    print('${qs.single}');
    return qs;
  }


  ///MAPS STUFF
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  List myMarker=[];




  _getCurrentLocation() {
    geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      // _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GoogleMap(
         myLocationButtonEnabled: true,
                     myLocationEnabled: true,
         zoomControlsEnabled: true,
                     zoomGesturesEnabled: true,
        //onTap: _handletap,
        //onMapCreated: onMapCreated(),
         onMapCreated: _onMapCreated,

                         //myMarker=[];
                        // _getAddressFromLatLng(tappedpoint.latitude,tappedpoint.longitude);
      //latx=tappedpoint.latitude;
      //lonx=tappedpoint.longitude;
                       /*  myMarker.add(

                             Marker(
                           markerId: MarkerId('User'),
                           position: LatLng(_currentPosition.latitude,_currentPosition.longitude),
                           draggable: true,

                           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                            onDragEnd: (dragPosition) async {
                                 print(dragPosition.toString());
                                 // _getAddressFromLatLng(tappedpoint.latitude,tappedpoint.longitude);
                //latx=tappedpoint.latitude;
                //lonx=tappedpoint.longitude;
                               }
                         )
                         );*/




        mapType: MapType.normal,
        //markers: Set.from(myMarker),
        initialCameraPosition: CameraPosition(target: LatLng(12.642748303085364, 77.43987996749236), zoom: 15),
      ),
    );
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




