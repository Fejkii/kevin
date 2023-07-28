import 'package:flutter/material.dart';
import 'package:kevin/ui/theme/app_colors.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final Function()? onTap;
  const AppListTile({
    Key? key,
    required this.title,
    this.leading,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      tileColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
