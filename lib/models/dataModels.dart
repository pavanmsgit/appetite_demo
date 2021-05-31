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
  String token;
  String platform;
  Timestamp created_at;

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
    this.token = map['token'];
    this.platform = map['platform'];
    this.created_at = map['createdAt'];
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
        this.shop_seller_number,
        this.token,
        this.platform,
        this.created_at});
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
        this.quantity = 1});

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
  String review_by_photo;
  String headline;

  DocumentReference reference;

  ShopReviews.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.review_id = map['review_id'];
    this.review_by_name = map['review_by_name'];
    this.review_by_id = map['review_by_id'];
    this.description = map['description'];
    this.ratings = map['ratings'];
    this.review_by_photo = map['review_by_photo'];
    this.headline = map['headline'];
  }

  ShopReviews.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  ShopReviews(
      {this.review_id,
        this.review_by_name,
        this.review_by_id,
        this.description,
        this.ratings,
        this.review_by_photo,
        this.headline});
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

  Categories({
    this.category_id,
    this.category_name,
    this.category_photo_url,
  });
}

class OrderModel {
  ShopItems shopItems;
  int quantity;

  OrderModel.fromMap(Map<dynamic, dynamic> map) {
    this.shopItems = ShopItems();
    this.quantity = map['quantity'];
  }

  OrderModel(this.shopItems, this.quantity);
}

class Orders {
  //ShopElements
  String order_otp;
  String order_id;
  String order_shop_id;
  String order_shop_name;
  String order_shop_logo;
  String order_shop_token; //new
  GeoPoint order_shop_location;
  double order_shop_overall_rating;
  String order_by_name;
  String order_by_phone;
  String order_by_uid;
  String order_by_token; //new
  String order_total_price;
  int order_total_quantity;
  int order_payment_mode;
  int order_pickup_mode;
  int order_status;
  String friend_uid;
  String friend_name;
  String friend_number;
  String friend_college;
  String friend_token;
  Timestamp order_timestamp;
  int order_payment_status;
  String order_seller_number;
  String order_payment_id;

  DocumentReference reference;

  Orders.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.order_otp = map['order_otp'];
    this.order_id = map['order_id'];
    this.order_shop_id = map['order_shop_id'];
    this.order_shop_name = map['order_shop_name'];
    this.order_shop_logo = map['order_shop_logo'];
    this.order_shop_location = map['order_shop_location'];
    this.order_shop_overall_rating = map['order_shop_overall_rating'];
    this.order_shop_token = map['order_shop_token'];
    this.order_by_name = map['order_by_name'];
    this.order_by_phone = map['order_by_phone'];
    this.order_by_uid = map['order_by_uid'];
    this.order_by_token = map['order_by_token'];
    this.order_total_price = map['order_total_price'];
    this.order_total_quantity = map['order_total_quantity'];
    this.order_payment_mode = map['order_payment_mode'];
    this.order_pickup_mode = map['order_pickup_mode'];
    this.order_status = map['order_status'];
    this.friend_uid = map['friend_uid'];
    this.friend_name = map['friend_name'];
    this.friend_number = map['friend_number'];
    this.friend_college = map['friend_college'];
    this.friend_token = map['friend_token'];
    this.order_timestamp = map['order_timestamp'];
    this.order_payment_status = map['order_payment_status'];
    this.order_seller_number = map['order_seller_number'];
    this.order_payment_id = map['order_payment_id'];
  }

  Orders.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Orders(
      { this.order_otp,
        this.order_id,
        this.order_shop_id,
        this.order_shop_name,
        this.order_shop_logo,
        this.order_shop_location,
        this.order_shop_overall_rating,
        this.order_shop_token,
        this.order_by_name,
        this.order_by_phone,
        this.order_by_uid,
        this.order_by_token,
        this.order_total_price,
        this.order_total_quantity,
        this.order_payment_mode,
        this.order_pickup_mode,
        this.order_status,
        this.friend_uid,
        this.friend_name,
        this.friend_number,
        this.friend_college,
        this.friend_token,
        this.order_timestamp,
        this.order_payment_status,
        this.order_seller_number,
        this.order_payment_id});
}

class OrderItems {
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

  OrderItems({
    this.order_id,
    this.item_name,
    this.item_photo,
    this.item_quantity,
    this.item_type,
    this.item_price,
  });
}

class UserDataModelMain {
  //ShopElements
  String user_id;
  String user_name;
  GeoPoint user_location;
  String user_logo;
  String user_phone;
  String user_email;
  String user_gender;
  String user_college_name;
  String token;
  String platform;
  Timestamp created_at;

  DocumentReference reference;

  UserDataModelMain.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.user_id = map['user_id'];
    this.user_name = map['user_name'];
    this.user_location = map['user_location'];
    this.user_logo = map['user_logo'];
    this.user_phone = map['user_phone'];
    this.user_email = map['user_email'];
    this.user_gender = map['user_gender'];
    this.user_college_name = map['user_college_name'];
    this.token = map['token'];
    this.platform = map['platform'];
    this.created_at = map['createdAt'];
  }

  UserDataModelMain.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  UserDataModelMain(
      {this.user_id,
        this.user_name,
        this.user_location,
        this.user_logo,
        this.user_phone,
        this.user_email,
        this.user_gender,
        this.user_college_name,
        this.token,
        this.platform,
        this.created_at});
}

class UserModelCustom {
  String id;
  String name;
  String phone;
  GeoPoint location;
  String gender;
  String collegeName;
  String photo;
  String token;

  UserModelCustom(this.id, this.name, this.phone, this.location, this.gender,
      this.collegeName, this.photo, this.token);
}

class ShopModelCustom {
  String id;
  String name;
  String phone;
  GeoPoint location;
  List<dynamic> cuisine;
  String logo;
  double ratings;


  ShopModelCustom(this.id, this.name, this.phone, this.location, this.cuisine,
      this.logo, this.ratings, );
}

class Notifications {
  //ShopElements
  String notification_id;
  String title;
  String description;
  String token;
  String platform;
  Timestamp created_at;


  ///FROM ORDERS

  String order_otp;
  String order_id;
  String order_shop_id;
  String order_shop_name;
  String order_shop_logo;
  String order_shop_token; //new
  GeoPoint order_shop_location;
  double order_shop_overall_rating;
  String order_by_name;
  String order_by_phone;
  String order_by_uid;
  String order_by_token; //new
  String order_total_price;
  int order_total_quantity;
  int order_payment_mode;
  int order_pickup_mode;
  int order_status;
  String friend_uid;
  String friend_name;
  String friend_number;
  String friend_college;
  String friend_token;
  Timestamp order_timestamp;
  int order_payment_status;
  String order_payment_id;
  String order_seller_number;

  DocumentReference reference;

  Notifications.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.notification_id = map['notification_id'];
    this.title = map['title'];
    this.description = map['description'];
    this.token = map['token'];
    this.platform = map['platform'];
    this.created_at = map['createdAt'];


    ///FROM ORDERS

    this.order_otp = map['order_otp'];
    this.order_id = map['order_id'];
    this.order_shop_id = map['order_shop_id'];
    this.order_shop_name = map['order_shop_name'];
    this.order_shop_logo = map['order_shop_logo'];
    this.order_shop_location = map['order_shop_location'];
    this.order_shop_overall_rating = map['order_shop_overall_rating'];
    this.order_shop_token = map['order_shop_token'];
    this.order_by_name = map['order_by_name'];
    this.order_by_phone = map['order_by_phone'];
    this.order_by_uid = map['order_by_uid'];
    this.order_by_token = map['order_by_token'];
    this.order_total_price = map['order_total_price'];
    this.order_total_quantity = map['order_total_quantity'];
    this.order_payment_mode = map['order_payment_mode'];
    this.order_pickup_mode = map['order_pickup_mode'];
    this.order_status = map['order_status'];
    this.friend_uid = map['friend_uid'];
    this.friend_name = map['friend_name'];
    this.friend_number = map['friend_number'];
    this.friend_college = map['friend_college'];
    this.friend_token = map['friend_token'];
    this.order_timestamp = map['order_timestamp'];
    this.order_payment_status = map['order_payment_status'];
    this.order_seller_number = map['order_seller_number'];
    this.order_payment_id = map['order_payment_id'];
  }

  Notifications.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Notifications(
      {this.notification_id,
        this.title,
        this.description,
        this.token,
        this.platform,
        this.created_at,


        ///FROM ORDERS


        this.order_otp,
        this.order_id,
        this.order_shop_id,
        this.order_shop_name,
        this.order_shop_logo,
        this.order_shop_location,
        this.order_shop_overall_rating,
        this.order_shop_token,
        this.order_by_name,
        this.order_by_phone,
        this.order_by_uid,
        this.order_by_token,
        this.order_total_price,
        this.order_total_quantity,
        this.order_payment_mode,
        this.order_pickup_mode,
        this.order_status,
        this.friend_uid,
        this.friend_name,
        this.friend_number,
        this.friend_college,
        this.friend_token,
        this.order_timestamp,
        this.order_payment_status,
        this.order_seller_number,
        this.order_payment_id
      });
}
