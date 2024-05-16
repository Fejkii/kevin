import 'package:flutter/material.dart';

class AppSubTitleText extends StatelessWidget {
  final String text;
  const AppSubTitleText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
