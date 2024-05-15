import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppSwitchWithText extends StatefulWidget {
  final String title;
  bool value;

  AppSwitchWithText({
    super.key,
    required this.title,
    this.value = false,
  });

  @override
  State<AppSwitchWithText> createState() => _AppSwitchWithTextState();
}

class _AppSwitchWithTextState extends State<AppSwitchWithText> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title),
          Switch(
            value: widget.value,
            onChanged: (bool val) {
              setState(() {
                widget.value = val;
              });
            },
          ),
        ],
      ),
      onTap: () {
        setState(() {
          widget.value = !widget.value;
        });
      },
    );
  }
}
