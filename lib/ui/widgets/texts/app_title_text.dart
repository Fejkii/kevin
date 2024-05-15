import 'package:flutter/material.dart';

class AppTitleText extends StatelessWidget {
  final String text;
  const AppTitleText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
