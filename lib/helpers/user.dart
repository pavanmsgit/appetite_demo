import 'package:appetite_demo/auth/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserServices {
  String collection = "adminDetails";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String adminPhoneNumber;

  void createUser(Map<String, dynamic> values) {
    String id = values["id"];
    _firestore.collection(collection).doc(id).set(values);
  }

  void updateUserData(Map<String, dynamic> values) {
    _firestore.collection(collection).doc(values['id']).update(values);
  }

  Future<UserModel> getUserById(String id) =>
      _firestore.collection(collection).doc(id).get().then((doc) {
        if (doc.data == null) {
          return null;
        }
        return UserModel.fromSnapshot(doc);
      });
}
