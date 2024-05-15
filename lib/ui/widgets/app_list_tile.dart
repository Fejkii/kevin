import 'package:flutter/material.dart';
import 'package:kevin/ui/theme/app_colors.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final Function()? onTap;
  const AppListTile({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      tileColor: AppColors.white,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(color: AppColors.border, width: 0.5),
      ),
    );
  }
}
