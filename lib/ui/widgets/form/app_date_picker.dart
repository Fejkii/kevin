import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../services/app_functions.dart';
import '../../../services/app_preferences.dart';
import '../../../services/dependency_injection.dart';

class AppDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final DateTime? initDate;
  final bool? fillTodayDate;
  final bool? setIcon;
  final bool? onlyYear;
  const AppDatePicker({
    super.key,
    required this.controller,
    this.label,
    this.initDate,
    this.fillTodayDate,
    this.setIcon,
    this.onlyYear,
  });

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  late DateTime todayDate;
  DateTime firstDate = DateTime(2000);
  DateTime lastDate = DateTime(2030);

  @override
  void initState() {
    super.initState();
    todayDate = DateTime.now();
    if (widget.fillTodayDate != false) {
      widget.controller.text = appFormatDateTime(todayDate, dateOnly: true);
    }
    if (widget.initDate != null) {
      widget.controller.text = appFormatDateTime(widget.initDate!, dateOnly: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: widget.setIcon != null ? const Icon(Icons.calendar_today, size: 17) : null,
        labelText: widget.label != null ? widget.label! : AppLocalizations.of(context)!.date,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        border: const OutlineInputBorder(),
      ),
      readOnly: true,
      onTap: () async {
        await showDatePicker(
          locale: Locale(instance<AppPreferences>().getAppLanguage()),
          context: context,
          initialDate: widget.initDate ?? todayDate,
          firstDate: firstDate,
          lastDate: lastDate,
          confirmText: AppLocalizations.of(context)!.ok,
          cancelText: AppLocalizations.of(context)!.cancel,
          helpText: AppLocalizations.of(context)!.selectDate,
          initialDatePickerMode: widget.onlyYear == true ? DatePickerMode.year : DatePickerMode.day,
        ).then((value) {
          if (value != null) {
            setState(() {
              widget.controller.text = appFormatDateTime(value, dateOnly: true);
            });
          }
          return null;
        });
      },
    );
  }
}
