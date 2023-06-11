// ignore_for_file: must_be_immutable, unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycafefrontend/MainPage.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'Login_customer.dart';
import 'Homepage.dart';
 Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String ans = prefs.getString('currentuser').toString();
  runApp(MyApp(ans));
  }
 class MyApp extends StatefulWidget {
  late String ans;
  MyApp(String ans)
  {
   
    this.ans=ans;
     
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
   @override
   Widget build(BuildContext context) {  
     print(widget.ans=='null');
     return MaterialApp(
       home: (widget.ans == 'null')?Homepage(): MainPage(),
     );
   }
}
 
 