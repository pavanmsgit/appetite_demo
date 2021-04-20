import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const NAME = "name";
  static const AUTHID = "authId";
  static const EMAIL = "email";
  static const ACCOUNTSTATUS = "accountStatus";
  static const PROFILEPHOTOURL = "profileUrl";

  String _name;
  String _authId;
  String _email;
  int _accountStatus;
  String _profileUrl;

//  getters
  String get name => _name;
  String get authId => _authId;
  String get email => _email;
  int get accountStatus => _accountStatus;
  String get profileUrl => _profileUrl;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot.data()[NAME];
    _authId = snapshot.data()[AUTHID];
    _email = snapshot.data()[EMAIL];
    _accountStatus = snapshot.data()[ACCOUNTSTATUS];
    _profileUrl = snapshot.data()[PROFILEPHOTOURL];
  }
}
