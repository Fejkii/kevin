import 'package:flutter/material.dart';
import 'package:kevin/ui/theme/app_colors.dart';

class AppFilterIconButton extends StatelessWidget {
  final int number;
  final Function() onPress;
  const AppFilterIconButton({
    super.key,
    required this.onPress,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Stack(
        children: [
          const Icon(Icons.filter_alt_outlined),
          if (number != 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
