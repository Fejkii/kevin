import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      style: GoogleFonts.sriracha(
        fontSize: 23,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
