import 'package:appetite_demo/models/dataModels.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

checkIPosterTypeAndReturnLayout(list , size) {
  //final posters = PosterList.fromSnapshot(snapshot.data.docs);

  List<dynamic> posterList = list;

  /*List<dynamic> iPosters = [
    'https://cdn.dribbble.com/users/2631664/screenshots/8269280/out_put_for_food__4x.png',
    'https://marcommnews.com/wp-content/uploads/2018/04/5acf5b01a9282-701x394.jpg',
    'https://i.ytimg.com/vi/WGyqJ-rqqtY/maxresdefault.jpg'
  ];*/

  final List<Widget> imageSliders = posterList
      .map((item) => Container(
            child: Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                        item,
                        width: size.width,
                        fit: BoxFit.fill,
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  return Container(
    padding: EdgeInsets.only(top: 20),
    child: CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        disableCenter: true,
        scrollPhysics: BouncingScrollPhysics(),
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
      ),
      items: imageSliders,
    ),
  );
}
