import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pankaj_dice_game/home.dart';
import 'package:pankaj_dice_game/leaderboard.dart';
import 'package:pankaj_dice_game/login_screen.dart';
import 'package:pankaj_dice_game/register.dart';
import 'package:pankaj_dice_game/splash.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
            appId: '1:454530283089:ios:190b57074464c5b7d06a70',
            apiKey: 'AIzaSyD1NjMizZuQDslA10DHCutQ0LDedspoEXk',
            projectId: 'my-project-1555305719675',
            messagingSenderId: '454530283089',
            databaseURL: 'https://my-project-1555305719675-default-rtdb.firebaseio.com/',
          )
        : FirebaseOptions(
            appId: '1:454530283089:android:0c122579ba1c5f65d06a70',
            apiKey: 'AIzaSyD1NjMizZuQDslA10DHCutQ0LDedspoEXk',
            messagingSenderId: '454530283089',
            projectId: 'my-project-1555305719675',
            databaseURL: 'https://my-project-1555305719675-default-rtdb.firebaseio.com/',
          ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (route) {
        switch (route.name) {
          case "/":
            return CupertinoPageRoute(builder: (_) => Splash());
            break;
          case "/login":
            return CupertinoPageRoute(builder: (_) => LoginScreen());
            break;
          case "/register":
            return CupertinoPageRoute(builder: (_) => Register());
            break;
          case "/home":
            return CupertinoPageRoute(builder: (_) => HomeScreen());
            break;
          case "/leader_board":
            return CupertinoPageRoute(builder: (_) => LeaderBoard());
            break;
        }
        return CupertinoPageRoute(builder: (_) => LoginScreen());
      },
      home: Splash(),
    );
  }
}
