import 'dart:math';

import 'package:appetite_demo/auth/googleSignIn.dart';
import 'package:appetite_demo/helpers/screenNavigation.dart';
import 'package:appetite_demo/helpers/style.dart';
import 'package:appetite_demo/mainScreens/login.dart';
import 'package:appetite_demo/mainScreens/preHome.dart';
import 'package:appetite_demo/mainScreens/splash.dart';
import 'package:appetite_demo/subPages/orderPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.notification.title,
      message.notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();



///MAIN METHOD
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
      ));


  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  ///RUN APP MAIN
  runApp(
      Phoenix(
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider.initialize())
      ],
      child: MyApp(),
    ),
  ));
  configLoading();
}


class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}


class MyAppState extends State<MyApp> {
  String token;

  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android?.smallIcon,
              ),
            ));
      }
    });
    getToken();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        title: 'Appetite',
        theme: ThemeData(
          primaryColor: tertiary,
        ),
        home: Phoenix(child: ScreensController()));
  }

  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = token;
    });
    print(token);
  }
}


class ScreensController extends StatefulWidget {
  @override
  _ScreensControllerState createState() => _ScreensControllerState();
}

class _ScreensControllerState extends State<ScreensController> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('firebase status check for account');
    final auth = Provider.of<AuthProvider>(context);
    print(auth.status);
    if (auth.status == Status.Uninitialized) {
      return Splash();
    } else {
      if (auth.status == Status.Authenticated) {
        return PreHome();
      } else {
        return Login();
      }
    }
  }
}



configLoading() {
  EasyLoading.instance
    ..displayDuration =  Duration(milliseconds: 3000)
    ..indicatorType = EasyLoadingIndicatorType.wave
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 65.0
    ..radius = 10.0
    ..progressColor = tertiary
    ..backgroundColor = tertiary
    ..indicatorColor = tertiary
    ..textColor = tertiary
    ..maskColor = tertiary.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = true;
}






























/*
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
*/





/*  AwesomeNotifications().initialize('resource://drawable/google',
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: secondary,
            ledColor: Colors.white),
        NotificationChannel(
            channelKey: 'badge_channel',
            channelName: 'Badge indicator notifications',
            channelDescription: 'Notification channel to activate badge indicator',
            channelShowBadge: true,
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.yellow),
        NotificationChannel(
            channelKey: 'ringtone_channel',
            channelName: 'Ringtone Channel',
            channelDescription: 'Channel with default ringtone',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
            defaultRingtoneType: DefaultRingtoneType.Ringtone),
        NotificationChannel(
            channelKey: 'updated_channel',
            channelName: 'Channel to update',
            channelDescription: 'Notifications with not updated channel',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white),
        NotificationChannel(
            channelKey: 'low_intensity',
            channelName: 'Low intensity notifications',
            channelDescription:
            'Notification channel for notifications with low intensity',
            defaultColor: Colors.green,
            ledColor: Colors.green,
            vibrationPattern: lowVibrationPattern),
        NotificationChannel(
            channelKey: 'medium_intensity',
            channelName: 'Medium intensity notifications',
            channelDescription:
            'Notification channel for notifications with medium intensity',
            defaultColor: Colors.yellow,
            ledColor: Colors.yellow,
            vibrationPattern: mediumVibrationPattern),
        NotificationChannel(
            channelKey: 'high_intensity',
            channelName: 'High intensity notifications',
            channelDescription:
            'Notification channel for notifications with high intensity',
            defaultColor: Colors.red,
            ledColor: Colors.red,
            vibrationPattern: highVibrationPattern),
        NotificationChannel(
            channelKey: "silenced",
            channelName: "Silenced notifications",
            channelDescription: "The most quiet notifications",
            playSound: false,
            enableVibration: false,
            enableLights: false),
        NotificationChannel(
            channelKey: 'big_picture',
            channelName: 'Big pictures',
            channelDescription: 'Notifications with big and beautiful images',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Color(0xFF9D50DD),
            vibrationPattern: lowVibrationPattern),
        NotificationChannel(
            channelKey: 'big_text',
            channelName: 'Big text notifications',
            channelDescription: 'Notifications with a expandable body text',
            defaultColor: Colors.blueGrey,
            ledColor: Colors.blueGrey,
            vibrationPattern: lowVibrationPattern),
        NotificationChannel(
            channelKey: 'inbox',
            channelName: 'Inbox notifications',
            channelDescription: 'Notifications with inbox layout',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Color(0xFF9D50DD),
            vibrationPattern: mediumVibrationPattern),

      ],
      debug: true
  );
*/
