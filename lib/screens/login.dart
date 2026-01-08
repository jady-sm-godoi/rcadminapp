import 'package:flutter/material.dart';
import 'package:rcadminapp/screens/profile_screem.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
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
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_){
                  return const ProfileScreem();
                })
              );
            },
            child: const Text('Go to Profile'),
          ),
        ],
      ),
    );
  }
}