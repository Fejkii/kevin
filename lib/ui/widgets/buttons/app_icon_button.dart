import 'package:flutter/material.dart';

enum IconButtonType {
  save,
  edit,
  add,
  delete,
  close,
}

class AppIconButton extends StatelessWidget {
  final IconButtonType iconButtonType;
  final Function() onPress;
  const AppIconButton({
    Key? key,
    required this.iconButtonType,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.image;
    switch (iconButtonType) {
      case IconButtonType.save:
        icon = Icons.save;
        break;
      case IconButtonType.edit:
        icon = Icons.edit;
        break;
      case IconButtonType.add:
        icon = Icons.add;
        break;
      case IconButtonType.delete:
        icon = Icons.delete_rounded;
        break;
      case IconButtonType.close:
        icon = Icons.close_rounded;
        break;
      default:
        break;
    }
    return IconButton(
      onPressed: onPress,
      icon: Icon(icon),
    );
  }
}
