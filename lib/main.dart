import 'package:Notes_final/Screens/add_edit_Note.dart';
import 'package:Notes_final/Storage/notes_database.dart';
import 'package:flutter/material.dart';
import './Screens/notes_main.dart';
import 'Screens/notes_main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  
  runApp(MyApp());
  
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  static FlutterLocalNotificationsPlugin flutterNotificationPlugin;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MyApp.flutterNotificationPlugin = new FlutterLocalNotificationsPlugin();
    var androidInitialization = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialization = IOSInitializationSettings();
    var initialize = InitializationSettings(androidInitialization, iosInitialization);
    MyApp.flutterNotificationPlugin.initialize(initialize, onSelectNotification: onSelectNotification);

  }

  Future<dynamic> onSelectNotification(String payload) async{
    print("$payload");
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
    
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notes",
      theme: ThemeData(
          primaryColor: Colors.white,
          canvasColor: Colors.white,
          primarySwatch: Colors.blue,
          accentColor: Colors.blueAccent),
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
