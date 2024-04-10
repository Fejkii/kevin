import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AppFloatingButton extends StatelessWidget {
  final dynamic Function() onPressed;
  const AppFloatingButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  FloatingActionButton build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      onPressed: onPressed,
      child: const Icon(Icons.add),
    );
  }
}
