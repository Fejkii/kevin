// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:kevin/services/app_preferences.dart';

import 'dependency_injection.dart';

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

String doubleValue(double? value) {
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  return value != null ? value.toString().replaceAll(regex, '') : "";
}

bool isIntegerValid(String value) {
  return RegExp(r"^[+-]?([0-9]+)$").hasMatch(value);
}

String appFormatDateTime(DateTime dateTime, {bool dateOnly = false}) {
  if (dateOnly) {
    return DateFormat.yMMMd(instance<AppPreferences>().getAppLanguage()).format(dateTime);
  }
  return DateFormat.yMMMd(instance<AppPreferences>().getAppLanguage()).add_Hms().format(dateTime);
}

DateTime appToDateTime(String dateTime) {
  return DateFormat.yMMMd(instance<AppPreferences>().getAppLanguage()).parse(dateTime);
}
