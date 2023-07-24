import 'package:flutter/material.dart';

enum ButtonType {
  logout,
  add,
}

class AppButton extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final ButtonType? buttonType;
  const AppButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.buttonType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (buttonType == ButtonType.logout) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.logout),
        label: Text(
          title,
        ),
      );
    }

    if (buttonType == ButtonType.add) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add),
        label: Text(
          title,
          style: const TextStyle(fontSize: 25),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onTap,
      child: Text(title),
    );
  }
}
