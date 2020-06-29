import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodload_flutter/screens/landing_screen.dart';
import 'package:foodload_flutter/screens/loading_screen.dart';
import 'package:foodload_flutter/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, userSnapshot) {
          return userSnapshot.hasData
              ? LandingScreen()
              : userSnapshot.connectionState == ConnectionState.waiting
                  ? LoadingScreen()
                  : LoginScreen();
        },
        //maybe add connectionState active as well
      ),
    );
  }
}
