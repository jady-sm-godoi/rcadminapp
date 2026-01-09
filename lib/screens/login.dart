import 'package:flutter/material.dart';
import 'package:rcadminapp/screens/profile_screem.dart';
import 'package:rcadminapp/widgets/login_form.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {

    //simulação de credenciais para enviar pela navegação como argumento
    final String usuario = 'admin';
    final String senha = 'admin123';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(95, 120, 138, 0.5),
                  Color.fromRGBO(36, 59, 85, 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            )
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoginForm(),
              ],
            ),
          )
        ],
      )
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Text('Login Screen'),
      //     ElevatedButton(
      //       onPressed: () {
      //         Navigator.of(context).pushNamed(
      //           '/profile',
      //           arguments: {
      //             'usuario': usuario,
      //             'senha': senha,
      //           },
      //         );
      //       },
      //       child: const Text('Go to Profile'),
      //     ),
      //   ],
      // ),
    );
  }
}