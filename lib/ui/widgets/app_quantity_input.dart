import 'package:flutter/material.dart';
import 'package:kevin/ui/theme/app_colors.dart';

import 'buttons/app_icon_button.dart';

class AppQuantityInput extends StatefulWidget {
  final int initValue;
  final String label;
  final int min;
  final int max;
  final int step;
  final Function(int) onChange;
  final Function() onSave;
  const AppQuantityInput({
    Key? key,
    required this.initValue,
    this.label = "",
    this.min = 0,
    this.max = 1000000,
    this.step = 1,
    required this.onChange,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AppQuantityInput> createState() => _AppQuantityInputState();
}

class _AppQuantityInputState extends State<AppQuantityInput> {
  final TextEditingController inputController = TextEditingController();
  late int _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initValue;
    inputController.text = _currentValue.toString();
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
            SizedBox(
              width: 100,
              child: TextField(
                controller: inputController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                keyboardType: TextInputType.number,
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
    setState(() {
      if (_currentValue < widget.max) {
        _currentValue += widget.step;
      }
      inputController.text = _currentValue.toString();
      widget.onChange(_currentValue);
    });
  }

  void _minus() {
    setState(() {
      if (_currentValue > widget.min) {
        _currentValue -= widget.step;
      }
      inputController.text = _currentValue.toString();
      widget.onChange(_currentValue);
    });
  }
}
