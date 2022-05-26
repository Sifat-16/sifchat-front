
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sifchat/models/userprofile.dart';
import 'package:sifchat/screens/auth/login/LoginScreen.dart';
import 'package:sifchat/screens/auth/services/authservice.dart';
import 'package:sifchat/screens/chat/homescreen.dart';
import 'package:sifchat/utility/mycolors.dart';

int? loggedin;
String? userId;
String? mytoken;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  loggedin = prefs.getInt("loggedin");
  userId = prefs.getString("userId");
  mytoken = prefs.getString("mytoken");
  print(userId);
  print(mytoken);

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: myBackground,
        statusBarBrightness: Brightness.dark
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  AuthService authService = AuthService();

  @override
  void initState() {
    // TODO: implement initState
    if(loggedin==null){
      setState(() {
        loggedin=0;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white
          )
      ),
      home: loggedin==0||userId==0?LoginPage():FutureBuilder<List<dynamic>>(
          future: authService.getUserData(userId!),
          builder: (context, snapshot){
            UserProfile userProfile = UserProfile();
              if(snapshot.hasData){
                if(snapshot.data!.length>1){
                  userProfile = snapshot.data![1];
                  userProfile.token = mytoken;
                }

              }
              return snapshot.hasData?ChatHome(userProfile: userProfile):Center(
                child: CircularProgressIndicator(),
              );
          }
      ),
    );
  }
}


