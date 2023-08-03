import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kevin/ui/theme/app_colors.dart';

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
          color = AppColors.green;
          break;
        case ToastState.warning:
          color = AppColors.yellow;
          break;
        case ToastState.error:
          color = AppColors.red;
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
