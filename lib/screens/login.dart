import 'package:flutter/material.dart';
import 'package:rcadminapp/screens/profile_screem.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Login Screen'),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/profile',
                arguments: {
                  'usuario': usuario,
                  'senha': senha,
                },
              );
            },
            child: const Text('Go to Profile'),
          ),
        ],
      ),
    );
  }
}