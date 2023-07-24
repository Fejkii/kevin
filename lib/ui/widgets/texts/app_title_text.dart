import 'package:flutter/material.dart';

class AppTitleText extends StatelessWidget {
  final String text;
  const AppTitleText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
