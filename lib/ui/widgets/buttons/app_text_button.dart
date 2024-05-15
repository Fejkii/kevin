import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Function() onTap;
  const AppTextButton({
    super.key,
    required this.title,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
