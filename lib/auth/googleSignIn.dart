import 'package:appetite_demo/auth/userData.dart';
import 'package:appetite_demo/auth/userModel.dart';
import 'package:appetite_demo/helpers/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Registered
}

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  UserServices _userServices = UserServices();
  UserModel _userModel;
  UserData _userData;
  User _user;
  Status _status = Status.Uninitialized;
  Status get status => _status;
  static const LOGGED_IN = "loggedIn";

  bool loggedIn;
  bool loggedOut;
  bool loading = false;

//getters
  UserModel get userModel => _userModel;
  UserData get userData => _userData;
  User get user => _user;
  UserServices _userServicse = UserServices();

  AuthProvider.initialize() {
    readPrefs();
  }

  Future<void> readPrefs() async {
    await Future.delayed(Duration(seconds: 5)).then((v) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      loggedIn = prefs.getBool('loggedIn');

      print('TYTYTTTTTTTTTTTTTTTTYTYTTTTTTTTTT $loggedIn');

      if (loggedIn == true) {
        _status = Status.Authenticated;
        notifyListeners();

        _user = _auth.currentUser;
        UserData().setUserLoggedIn(
            user.uid, user.displayName, user.email, user.photoURL);
        return;
      } else {
        _status = Status.Unauthenticated;
        notifyListeners();
      }
    });
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuth =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuth.accessToken,
      idToken: googleSignInAuth.idToken,
    );
    print(googleSignInAuth.accessToken);
    try {
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User user = authResult.user;

      assert(user.email != null);
      assert(user.displayName != null);

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      print(user.photoURL);
      print(user.email);
      print(user.uid);
      print(user.displayName);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('authId', user.uid);
      prefs.setString('name', user.displayName);
      prefs.setString('email', user.email);
      prefs.setString('photoUrl', user.photoURL);
      prefs.setBool('loggedIn', true);

      _status = Status.Authenticated;
      notifyListeners();

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      print('ISISISISIISISISS $user');
    } catch (e) {
      print("${e.toString()}");
    }
    print('status changed to authenticated');
    mark();
    print('Executed mark');
    return true;
  }

  mark() async {
    _status = Status.Authenticated;
    notifyListeners();
  }

/*
void createUser({String id, String name, String email, String photoUrl}) {
  _userServices.createUser({
    "accountStatus": 1,
    "authId": id,
    "email": email,
    "name": name,
    "profileUrl": photoUrl
  });
}
*/

  void signOutGoogle() async {
    print('yes signed out');
    _status = Status.Unauthenticated;
    await googleSignIn.signOut();
  }

  Future<bool> logout(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF321833),
        title: Text(
          "Confirm Log out?",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "No",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.setBool('loggedIn', false);
              await UserData().logoutUserFromDevice();
              signOutGoogle();
              Phoenix.rebirth(context);
            },
          ),
        ],
      ),
    );
  }
}
