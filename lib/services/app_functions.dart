// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:kevin/const/app_units.dart';
import 'package:kevin/services/app_preferences.dart';

import 'dependency_injection.dart';
import 'language_service.dart';

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
  if (value.length > 18) {
    return false;
  }
  return RegExp(r"^[+-]?([0-9]+)$").hasMatch(value);
}

String _numberFormat(dynamic number, int? decimalDigits) {
  NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: LanguageCodeEnum.czech.getValue(),
    decimalDigits: decimalDigits ?? 0,
  );

  return formatter.format(number);
}

String appFormatDoubleToString(double? value) {
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  return value != null ? value.toString().replaceAll(regex, '') : "";
}

double? appFormatStringToDouble(String? value) {
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  return value != null && value != "" ? double.parse(value.replaceAll(regex, "")) : null;
}

String appFormatLiter(dynamic number, BuildContext context) {
  return "${_numberFormat(number, 0)} ${AppUnits().liter(number.toString(), context)}";
}

String appFormatPercent(dynamic number) {
  return "${appFormatDoubleToString(number)} ${AppUnits.percent}";
}

String appFormatGramPerLiter(dynamic number) {
  return "${appFormatDoubleToString(number)} ${AppUnits.gramPerLiter}";
}

String appFormatQuantity(dynamic number) {
  return "${appFormatDoubleToString(number)} ${AppUnits.quantity}";
}

String appFormatPriceWithUnit(dynamic number) {
  return "${appFormatDoubleToString(number)} ${AppUnits.crown}";
}

String appFormatPriceToTextField(dynamic number) {
  NumberFormat formatter = NumberFormat();
  formatter.minimumFractionDigits = 0;
  formatter.maximumFractionDigits = 2;

  return formatter.format(number);
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
