import 'package:flutter/material.dart';
import 'package:kevin/ui/theme/app_colors.dart';

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
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        label: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
      );
    }

    if (buttonType == ButtonType.add) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        label: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
