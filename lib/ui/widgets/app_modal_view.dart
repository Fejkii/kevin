import 'package:flutter/material.dart';
import 'package:kevin/ui/widgets/buttons/app_icon_button.dart';
import 'package:kevin/ui/widgets/texts/app_title_text.dart';

class AppModalView extends StatelessWidget {
  final String title;
  final Widget content;

  const AppModalView({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _firstRow(context),
            const SizedBox(height: 10),
            content,
          ],
        ),
      ),
    );
  }

  Widget _firstRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppTitleText(text: title),
        AppIconButton(
          iconButtonType: IconButtonType.close,
          onPress: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
