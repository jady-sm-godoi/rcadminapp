import 'package:flutter/material.dart';

class RcaHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const RcaHeaderBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: false,
        title: const Text(
          'rc@dmin app',
          style: TextStyle(color: Color.fromRGBO(135, 118, 78, 1)),
        ),
        elevation: 5,
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        foregroundColor: Colors.black,
        shadowColor: Colors.black,
        toolbarHeight: 72,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings_outlined,
              color: Color.fromRGBO(135, 118, 78, 1),
            ),
          ),
        ],
      );
  }
}