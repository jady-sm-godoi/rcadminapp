import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcadminapp/models/auth.dart';
import 'package:rcadminapp/screens/edit_profile_screen.dart';
import 'package:rcadminapp/screens/login.dart';
import 'package:rcadminapp/screens/paginanaoencontrada.dart';
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth())
      ],
      child: MaterialApp(
        routes: { //rotas oficiais
          '/': (_) => const Login(),
          '/profile': (_) => const ProfileScreem(),
          '/edit_profile': (_) => const EditProfileScreen(),
        },
      
        onGenerateRoute: (settings) { // rotas dinâmicas (ex: com parâmetros, perfil específico, etc)
          if (settings.name == '/rota-especial') {
            return MaterialPageRoute(builder: (_) => const Login());
          }
          return null; // IMPORTANTE
        },
      
        onUnknownRoute: (_) => MaterialPageRoute( // rota para páginas não encontradas (404)
          builder: (_) => const Paginanaoencontrada(),
        ),
      ),
    );
  }
}