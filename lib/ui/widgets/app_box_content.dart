import 'package:flutter/material.dart';
import 'package:kevin/ui/theme/app_colors.dart';

class AppBoxContent extends StatelessWidget {
  final String? title;
  final Widget child;
  const AppBoxContent({
    Key? key,
    this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        if (title != null)
          Text(
            title!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (title != null) const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              width: 0.5,
              color: AppColors.border,
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}
