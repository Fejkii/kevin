import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppUnits {
  static const String miliLiter = "ml";
  static const String percent = "%";
  static const String squareMeter = "m\u00B2";
  static const String gramPerLiter = "g/l";
  static const String miliGramPerLiter = "mg/l";
  static const String crown = "Kč";
  static const String quantity = "ks";
  static const String kilogram = "kg";

  static const List<String> tradeUnits = <String>[quantity, kilogram, miliLiter];

  String liter(String number, BuildContext context) {
    return number != "" ? AppLocalizations.of(context)!.unitLiter(double.parse(number)) : AppLocalizations.of(context)!.unitLiter(0);
  }
}
