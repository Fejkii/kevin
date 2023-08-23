import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/app_functions.dart';
import '../theme/app_colors.dart';
import 'buttons/app_icon_button.dart';

class AppQuantityInput extends StatefulWidget {
  final TextEditingController inputController;
  final int initValue;
  final String label;
  final int min;
  final int max;
  final int step;
  final String? unit;
  final Function(int) onChange;
  final Function() onSave;
  const AppQuantityInput({
    Key? key,
    required this.inputController,
    required this.initValue,
    this.label = "",
    this.min = 0,
    this.max = 0x7FFFFFFFFFFFFFFF,
    this.step = 1,
    this.unit,
    required this.onChange,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AppQuantityInput> createState() => _AppQuantityInputState();
}

class _AppQuantityInputState extends State<AppQuantityInput> {
  late int _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initValue;
    widget.inputController.text = _currentValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.label != "" ? Text(widget.label) : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _iconButton(
              () => _minus(),
              Icons.remove,
            ),
            IntrinsicWidth(
              child: TextFormField(
                controller: widget.inputController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  suffix: showUnit(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty && !isIntegerValid(value)) {
                    return AppLocalizations.of(context)!.valueError;
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  setState(() {
                    if (value != "" && value.length < 18) {
                      if (int.parse(value) <= widget.max && int.parse(value) >= widget.min) {
                        widget.onChange(int.parse(value));
                      }
                    } else {
                      widget.onChange(0);
                    }
                  });
                },
              ),
            ),
            _iconButton(
              () => _plus(),
              Icons.add,
            ),
            AppIconButton(
              iconButtonType: IconButtonType.save,
              onPress: widget.onSave,
            ),
          ],
        ),
      ],
    );
  }

  Widget? showUnit() {
    if (widget.unit != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Text(
          widget.unit!,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }
    return null;
  }

  Widget _iconButton(Function() onPressed, IconData icon) {
    return CircleAvatar(
      backgroundColor: AppColors.grey,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: AppColors.primary,
      ),
    );
  }

  void _plus() {
    if (widget.inputController.text != "") {
      _currentValue = int.parse(widget.inputController.text);
      setState(() {
        if (_currentValue <= widget.max) {
          _currentValue += widget.step;
        }
        widget.onChange(_currentValue);
        widget.inputController.text = _currentValue.toString();
      });
    } else {
      _currentValue = widget.step;
      widget.onChange(_currentValue);
      widget.inputController.text = _currentValue.toString();
    }
  }

  void _minus() {
    if (widget.inputController.text != "") {
      _currentValue = int.parse(widget.inputController.text);
      setState(() {
        if (_currentValue >= widget.min) {
          if (_currentValue >= widget.step) {
            _currentValue -= widget.step;
          } else {
            _currentValue = 0;
          }
        }
        widget.onChange(_currentValue);
        widget.inputController.text = _currentValue.toString();
      });
    } else {
      _currentValue = 0;
      widget.onChange(_currentValue);
      widget.inputController.text = _currentValue.toString();
    }
  }
}
