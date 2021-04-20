import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  Future setUserLoggedIn(
      String id, String name, String email, String photoUrl) async {
    print('????????????????????????/');
    print(id);
    print(name);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('authId', id);
    prefs.setString('name', name);
    prefs.setString('email', email);
    prefs.setString('photoUrl', photoUrl);
    prefs.setBool('loggedIn', true);
  }

  Future getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getString('authId'),
      prefs.getString('name'),
      prefs.getString('email'),
      prefs.getString('photoUrl'),
    ];
  }

  Future setUserStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedId', true);
  }

  Future getUserStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedId');
  }

  Future getUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn');
  }

  Future logoutUserFromDevice() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('authId', '');
    prefs.setString('name', '');
    prefs.setString('email', '');
    prefs.setString('photoUrl', '');
    prefs.setBool('loggedIn', false);
  }
}
