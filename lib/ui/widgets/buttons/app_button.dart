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
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.grey,
        ),
        label: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.red,
      ),
      child: Text(title),
    );
  }
}
