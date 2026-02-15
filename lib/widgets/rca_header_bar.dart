import 'package:flutter/material.dart';

class RcaHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final String subtitle;

  const RcaHeaderBar({super.key, this.subtitle = ''});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'rc@dmin app',
                style: TextStyle(
                  color: Color.fromRGBO(135, 118, 78, 1), 
                  fontSize: 16, 
                  fontWeight: FontWeight.bold
                  )
                ),
                const SizedBox(height: 8),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
                    fontSize: 18,
                  ),
                ),
            ],
          ),
        ),
        elevation: 5,
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        foregroundColor: Colors.black,
        shadowColor: Colors.black,
        toolbarHeight: 75,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        // ),
      );
  }
}