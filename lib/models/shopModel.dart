import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  //ShopElements
  String shop_id;
  String shop_name;
  String shop_logo;
  GeoPoint shop_location;
  double shop_overall_rating;
  List<dynamic> shop_cuisine;
  int shop_average_price;
  bool offer_exist;
  int offer_percentage;
  int shop_priority;
  Timestamp shop_live;
  int shop_active_hours_open;
  int shop_active_hours_close;
  List<dynamic> shop_name_search;

  DocumentReference reference;

  Shop.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.shop_id = map['shop_id'];
    this.shop_name = map['shop_name'];
    this.shop_logo = map['shop_logo'];
    this.shop_location = map['shop_location'];
    this.shop_overall_rating = map['shop_overall_rating'];
    this.shop_cuisine = map['shop_cuisine'];
    this.shop_average_price = map['shop_average_price'];
    this.offer_exist = map['offer_exist'];
    this.offer_percentage = map['offer_percentage'];
    this.shop_priority = map['shop_priority'];
    this.shop_live = map['shop_live'];
    this.shop_active_hours_open = map['shop_active_hours_open'];
    this.shop_active_hours_close = map['shop_active_hours_close'];
    this.shop_name_search = map['shop_name_search'];
  }

  Shop.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Shop(
      {this.shop_id,
      this.shop_name,
      this.shop_logo,
      this.shop_location,
      this.shop_overall_rating,
      this.shop_cuisine,
      this.shop_average_price,
      this.offer_exist,
      this.offer_percentage,
      this.shop_priority,
      this.shop_live,
      this.shop_active_hours_open,
      this.shop_active_hours_close,
      this.shop_name_search});
}



class ShopItems {
  //ShopElements
  String item_id;
  String item_name;
  String item_photo;
  double item_price;
  int item_type;


  DocumentReference reference;

  ShopItems.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.item_id = map['item_id'];
    this.item_name = map['item_name'];
    this.item_photo = map['item_photo'];
    this.item_price = map['item_price'];
    this.item_type = map['item_type'];
  }

  ShopItems.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  ShopItems(
      {this.item_id,
        this.item_name,
        this.item_photo,
        this.item_price,
        this.item_type,
       });
}




class ShopReviews {
  //ShopElements
  String review_id;
  String review_by_name;
  String review_by_id;
  String description;
  double ratings;


  DocumentReference reference;

  ShopReviews.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.review_id = map['item_id'];
    this.review_by_name = map['item_name'];
    this.review_by_id = map['shop_logo'];
    this.description = map['shop_overall_rating'];
    this.ratings = map['shop_average_price'];
  }

  ShopReviews.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  ShopReviews(
      {this.review_id,
        this.review_by_name,
        this.review_by_id,
        this.description,
        this.ratings,
      });
}



class Categories {
  //ShopElements
  int category_id;
  String category_name;
  String category_photo_url;



  DocumentReference reference;

  Categories.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.category_id = map['category_id'];
    this.category_name = map['category_name'];
    this.category_photo_url = map['category_photo_url'];

  }

  Categories.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Categories(
      {this.category_id,
        this.category_name,
        this.category_photo_url,

      });
}
