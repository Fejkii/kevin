import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastState {
  success,
  error,
  warning,
}

class AppToastMessage {
  void showToastMsg(String message, ToastState toastState) {
    Color chooseToastColor({required ToastState state}) {
      Color color;
      switch (state) {
        case ToastState.success:
          color = Colors.green;
          break;
        case ToastState.warning:
          color = Colors.yellow;
          break;
        case ToastState.error:
          color = Colors.red;
          break;
      }
      return color;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state: toastState),
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }
}