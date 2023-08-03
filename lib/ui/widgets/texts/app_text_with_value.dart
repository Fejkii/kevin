import 'package:flutter/material.dart';
import 'package:kevin/ui/widgets/texts/app_content_text.dart';

class AppTextWithValue extends StatelessWidget {
  final String text;
  final dynamic value;
  final bool? separator;
  final String? unit;
  const AppTextWithValue({
    Key? key,
    required this.text,
    required this.value,
    this.unit,
    this.separator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String content;
    content = unit != null ? "${value.toString()} $unit" : value.toString();
    return Row(
      children: [
        AppContentText(text: text),
        separator == false ? Container() : const AppContentText(text: ": "),
        Text(
          content,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
