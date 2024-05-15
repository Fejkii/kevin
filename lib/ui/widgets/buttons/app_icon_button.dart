import 'package:flutter/material.dart';

enum IconButtonType {
  save,
  edit,
  add,
  delete,
  close,
  search,
  arrow_back,
}

class AppIconButton extends StatelessWidget {
  final IconButtonType iconButtonType;
  final Function() onPress;
  const AppIconButton({
    super.key,
    required this.iconButtonType,
    required this.onPress,
  });

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
      case IconButtonType.search:
        icon = Icons.search;
        break;
      case IconButtonType.arrow_back:
        icon = Icons.arrow_back;
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
