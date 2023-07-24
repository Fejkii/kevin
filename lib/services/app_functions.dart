import 'package:flutter/material.dart';

bool isEmailValid(String email) {
  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

bool isPasswordValid(String password) {
  return RegExp(r"^.{6,}$").hasMatch(password);
}

bool isTitleValid(String title) {
  return RegExp(r"^.{2,}$").hasMatch(title);
}

bool isDoubleValid(String value) {
  return RegExp(r"^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$").hasMatch(value);
}

bool isIntegerValid(String value) {
  return RegExp(r"^[+-]?([0-9]+)$").hasMatch(value);
}

Future<void> appLoadingIndicator(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    },
  );
}
