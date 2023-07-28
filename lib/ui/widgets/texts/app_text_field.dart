import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/services/app_functions.dart';
import 'package:kevin/ui/theme/app_colors.dart';

enum InputType {
  email,
  password,
  title,
  note,
  double,
  integer,
}

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  // if inputType is entered, the input value is validated by the inputType
  // if inputType is entered, icon for textField is set by the inputType;
  // icon attribute can override this icon
  final InputType? inputType;
  final bool? isRequired;
  final String? errorMessage;
  final IconData? icon;
  final String? unit;
  final Function(String)? onChange;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.inputType,
    this.isRequired = false,
    this.errorMessage,
    this.icon,
    this.unit,
    this.onChange,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = true;

  Widget? showPasswordIcon() {
    if (widget.inputType == InputType.password) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
        child: GestureDetector(
          onTap: _toggleObscured,
          child: Icon(
            _obscured ? Icons.visibility_rounded : Icons.visibility_off_rounded,
            size: 24,
          ),
        ),
      );
    }
    return null;
  }

  Widget? showUnit() {
    if (widget.unit != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
        child: Text(
          widget.unit!,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }
    return null;
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    IconData? iconData;
    if (widget.icon != null) {
      iconData = widget.icon;
    } else {
      switch (widget.inputType) {
        case InputType.email:
          iconData = Icons.email;
          break;
        case InputType.password:
          iconData = Icons.lock;
          break;
        case InputType.title:
          iconData = Icons.title;
          break;
        case InputType.double:
          iconData = Icons.numbers;
          break;
        case InputType.integer:
          iconData = Icons.numbers;
          break;
        default:
          break;
      }
    }

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: widget.inputType == InputType.password ? _obscured : false,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        prefixIcon: iconData != null
            ? Icon(
                iconData,
                size: 17,
              )
            : null,
        isDense: true,
        suffixIcon: widget.unit != null ? showUnit() : showPasswordIcon(),
      ),
      maxLines: widget.inputType == InputType.note ? 3 : 1,
      validator: (value) {
        if (widget.isRequired == true) {
          if (value == null || value.isEmpty) {
            return widget.errorMessage ?? AppLocalizations.of(context)!.inputEmpty;
          }
        }
        switch (widget.inputType) {
          case InputType.email:
            if (value != null && value.isNotEmpty && !isEmailValid(value)) {
              return AppLocalizations.of(context)!.emailError;
            }
            break;
          case InputType.password:
            if (value != null && value.isNotEmpty && !isPasswordValid(value)) {
              return AppLocalizations.of(context)!.passwordError;
            }
            break;
          case InputType.title:
            if (value != null && value.isNotEmpty && !isTitleValid(value)) {
              return AppLocalizations.of(context)!.titleError;
            }
            break;
          case InputType.double:
            if (value != null && value.isNotEmpty && !isDoubleValid(value)) {
              return AppLocalizations.of(context)!.valueError;
            }
            break;
          case InputType.integer:
            if (value != null && value.isNotEmpty && !isIntegerValid(value)) {
              return AppLocalizations.of(context)!.valueError;
            }
            break;
          default:
            return null;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: widget.onChange,
    );
  }
}
