import 'package:flutter/material.dart';

class AppTextWithUnit extends StatelessWidget {
  final String title;
  final String unit;
  const AppTextWithUnit({
    super.key,
    required this.title,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Text("$title $unit");
  }
}
