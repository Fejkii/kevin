import 'package:flutter/material.dart';

class AppTextWithUnit extends StatelessWidget {
  final String title;
  final String unit;
  const AppTextWithUnit({
    Key? key,
    required this.title,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("$title $unit");
  }
}
