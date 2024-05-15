import 'package:flutter/material.dart';

class AppContentText extends StatelessWidget {
  final String text;
  final double size;
  const AppContentText({
    super.key,
    required this.text,
    this.size = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
