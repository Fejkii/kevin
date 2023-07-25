import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/ui/widgets/buttons/app_text_button.dart';
import 'package:kevin/ui/widgets/texts/app_content_text.dart';
import 'package:kevin/ui/widgets/texts/app_title_text.dart';

class AppModalDialog extends StatefulWidget {
  final String title;
  final String content;
  final Function() onTap;
  const AppModalDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AppModalDialog> createState() => _AppModalDialogState();
}

class _AppModalDialogState extends State<AppModalDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AppTitleText(text: widget.title),
      content: AppContentText(text: widget.content),
      actions: [
        AppTextButton(
          title: AppLocalizations.of(context)!.cancel,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        AppTextButton(title: AppLocalizations.of(context)!.ok, onTap: widget.onTap),
      ],
    );
  }
}
