import 'package:flutter/material.dart';

class RcaBackground extends StatelessWidget {
  final Widget child;
  final bool addPaddingTop;

  const RcaBackground({super.key, required this.child, this.addPaddingTop = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: addPaddingTop ? const EdgeInsets.only(top: 130, bottom: 50) : null,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(95, 120, 138, 0.5),
            Color.fromRGBO(36, 59, 85, 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
