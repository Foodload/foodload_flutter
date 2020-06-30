import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodload_flutter/models/app_theme.dart';
import 'package:foodload_flutter/providers/auth.dart';
import 'package:foodload_flutter/screens/landing_screen.dart';
import 'package:foodload_flutter/screens/loading_screen.dart';
import 'package:foodload_flutter/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Login',
        theme: AppTheme.darkTheme,
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
      ),
    );
  }
}
