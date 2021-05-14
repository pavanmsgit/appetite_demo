import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const NAME = "name";
  static const AUTHID = "authId";
  static const EMAIL = "email";
  static const ACCOUNTSTATUS = "accountStatus";
  static const PROFILEPHOTOURL = "profileUrl";
  static const PHONE = 'phone';

  String _name;
  String _authId;
  String _email;
  int _accountStatus;
  String _profileUrl;
  String _phone;

//  getters
  String get name => _name;
  String get authId => _authId;
  String get email => _email;
  int get accountStatus => _accountStatus;
  String get profileUrl => _profileUrl;
  String get phone => _phone;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot.data()[NAME];
    _authId = snapshot.data()[AUTHID];
    _email = snapshot.data()[EMAIL];
    _accountStatus = snapshot.data()[ACCOUNTSTATUS];
    _profileUrl = snapshot.data()[PROFILEPHOTOURL];
    _phone = snapshot.data()[PHONE];
  }
}
