import 'package:firebase_12dec/screens/home_screen.dart';
import 'package:firebase_12dec/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_12dec/screens/signin_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.dark,
    ),
    home: StreamBuilder(
      stream: AuthService().firebaseauth.authStateChanges(),
      builder: (context,AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return HomeScreen(snapshot.data);
        }
        return RegisterScreen();
      },
    ),
  ));
}
