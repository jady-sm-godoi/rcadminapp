import 'package:flutter/material.dart';
import 'package:rcadminapp/screens/login.dart';
import 'package:rcadminapp/screens/profile_screem.dart';
import 'dart:io';

//TODO: Remove this HttpOverrides in production code
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
    HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      routes: {
        '/': (context) => Login(),
        '/profile': (context) => ProfileScreem(),
      },
    );
  }
}