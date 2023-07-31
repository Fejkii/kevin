import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppUnits {
  static const String miliLiter = "ml";
  static const String percent = "%";
  static const String squareMeter = "m\u00B2";
  static const String gramPerOneLiter = "g/1l";

  String liter(TextEditingController controller, BuildContext context) {
    return controller.text != ""
        ? AppLocalizations.of(context)!.unitLiter(double.parse(controller.text))
        : AppLocalizations.of(context)!.unitLiter(0);
  }
}
