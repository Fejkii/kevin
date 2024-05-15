import 'package:flutter/material.dart';
import 'package:kevin/ui/widgets/buttons/app_icon_button.dart';
import 'package:kevin/ui/widgets/texts/app_title_text.dart';

Future<T?> appShowModal<T>({
  required BuildContext context,
  required String title,
  required Widget content,
}) {
  return showModalBottomSheet<T>(
    isScrollControlled: true,
    context: context,
    builder: (context) => AppModalView(
      title: title,
      content: content,
    ),
  );
}

class AppModalView extends StatelessWidget {
  final String title;
  final Widget content;

  const AppModalView({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              _firstRow(context),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 10),
                    content,
                  ],
                ),
              ),
            ],
          ),
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
