import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  //ShopElements
  String shop_id;
  String shop_name;
  String shop_logo;
  GeoPoint shop_location;
  double shop_overall_rating;
  List<dynamic> shop_cuisine;
  String shop_average_price;
  bool offer_exist;
  int offer_percentage;
  int shop_priority;
  Timestamp shop_live;
  String shop_active_hours_open;
  String shop_active_hours_close;
  List<dynamic> shop_name_search;
  String shop_seller_number;

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
    this.shop_seller_number = map['shop_seller_number'];
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
      this.shop_name_search,
      this.shop_seller_number});
}


class ShopItems {
  //ShopElements
  String item_id;
  String item_name;
  String item_photo;
  String item_price;
  int item_type;
  List<dynamic> item_name_search;
  int quantity;


  DocumentReference reference;

  ShopItems.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.item_id = map['item_id'];
    this.item_name = map['item_name'];
    this.item_photo = map['item_photo'];
    this.item_price = map['item_price'];
    this.item_type = map['item_type'];
    this.item_name_search = map['item_name_search'];
    this.quantity = 1;
  }

  ShopItems.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  ShopItems(
      {this.item_id,
        this.item_name,
        this.item_photo,
        this.item_price,
        this.item_type,
        this.item_name_search,
        this.quantity=1
       });

  void incrementQuantity() {
    this.quantity = this.quantity + 1;
  }

  void decrementQuantity() {
    this.quantity = this.quantity - 1;
  }

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


class OrderModel{
  ShopItems shopItems;
  int quantity;


  OrderModel.fromMap(Map<dynamic, dynamic> map) {
    this.shopItems = ShopItems();
    this.quantity = map['quantity'];
  }

  OrderModel(this.shopItems, this.quantity);

}


class Orders{
  //ShopElements
  String order_id;
  String order_shop_id;
  String order_shop_name;
  String order_shop_logo;
  GeoPoint order_shop_location;
  double order_shop_overall_rating;
  String order_by_name;
  String order_by_phone;
  String order_by_uid;
  String order_total_price;
  int order_total_quantity;
  int order_payment_mode;
  int order_pickup_mode;
  int order_status;
  String friend_name;
  String friend_number;
  Timestamp order_timestamp;


  DocumentReference reference;

  Orders.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.order_id = map['order_id'];
    this.order_shop_id = map['order_shop_id'];
    this.order_shop_name = map['order_shop_name'];
    this.order_shop_logo = map['order_shop_logo'];
    this.order_shop_location = map['order_shop_location'];
    this.order_shop_overall_rating = map['order_shop_overall_rating'];
    this.order_by_name = map['order_by_name'];
    this.order_by_phone = map['order_by_phone'];
    this.order_by_uid = map['order_by_uid'];
    this.order_total_price = map['order_total_price'];
    this.order_total_quantity = map['order_total_quantity'];
    this.order_payment_mode = map['order_payment_mode'];
    this.order_pickup_mode = map['order_pickup_mode'];
    this.order_status = map['order_status'];
    this.friend_name=map['friend_name'];
    this.friend_number=map['friend_number'];
    this.order_timestamp = map['order_timestamp'];
  }

  Orders.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Orders(
      {this.order_id,
        this.order_shop_id,
        this.order_shop_name,
        this.order_shop_logo,
        this.order_shop_location,
        this.order_shop_overall_rating,
        this.order_by_name,
        this.order_by_phone,
        this.order_by_uid,
        this.order_total_price,
        this.order_total_quantity,
        this.order_payment_mode,
        this.order_pickup_mode,
        this.order_status,
        this.friend_name,
        this.friend_number,
        this.order_timestamp
      });

}


class OrderItems{
  //ShopElements
  String order_id;
  String item_name;
  String item_photo;
  int item_quantity;
  int item_type;
  String item_price;


  DocumentReference reference;

  OrderItems.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.order_id = map['order_id'];
    this.item_name = map['item_name'];
    this.item_photo = map['item_photo'];
    this.item_quantity = map['item_quantity'];
    this.item_type = map['item_type'];
    this.item_price = map['item_price'];
  }

  OrderItems.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  OrderItems(
      {this.order_id,
        this.item_name,
        this.item_photo,
        this.item_quantity,
        this.item_type,
        this.item_price,
      });

}






