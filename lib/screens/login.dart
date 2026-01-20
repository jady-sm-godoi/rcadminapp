import 'package:flutter/material.dart';
import 'package:rcadminapp/widgets/login_form.dart';
import 'package:rcadminapp/widgets/rca_drawer.dart';
import 'package:rcadminapp/widgets/rca_header_bar.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: RcaHeaderBar(),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(95, 120, 138, 0.5),
                  Color.fromRGBO(36, 59, 85, 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [LoginForm()],
            ),
          ),
        ],
      ),
    );
  }
}
