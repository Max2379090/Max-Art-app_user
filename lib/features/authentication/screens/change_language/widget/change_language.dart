import 'package:flutter/material.dart';

class Tchange_language extends StatelessWidget {
  const Tchange_language({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 25,
      left: 30,
      bottom: 110,
      child: IconButton(
        icon: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.language, size: 20, color: Colors.blueAccent),
            SizedBox(width: 8), // Adds some space between the icon and text
            Text(
              'Language',
              style: TextStyle(
                fontSize: 13,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ), onPressed: () {  },
      ),
    );
  }
}