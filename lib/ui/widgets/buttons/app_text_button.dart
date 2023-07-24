import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  const AppTextButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(title),
    );
  }
}
