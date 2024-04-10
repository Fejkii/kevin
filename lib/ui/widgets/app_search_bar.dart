import 'package:flutter/material.dart';
import 'package:kevin/const/app_constant.dart';
import 'package:kevin/ui/widgets/buttons/app_icon_button.dart';

class AppSearchBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  // if enableSearch is true, searchController must is required too
  final bool? enableSearch;
  final TextEditingController? searchController;

  const AppSearchBar({
    Key? key,
    this.title,
    this.actions,
    this.leading,
    this.enableSearch,
    this.searchController,
  }) : super(key: key);

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _AppSearchBarState extends State<AppSearchBar> {
  bool isSearchVisible = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearchVisible
          ? _searchTextField()
          : widget.title != AppConstant.EMPTY
              ? Text(widget.title!)
              : null,
      actions: _actions(),
      leading: widget.leading,
    );
  }

  List<Widget>? _actions() {
    if (isSearchVisible) {
      return [
        AppIconButton(
          iconButtonType: IconButtonType.close,
          onPress: () {
            setState(() {
              if (isSearchVisible && widget.searchController!.text != AppConstant.EMPTY) {
                widget.searchController!.text = AppConstant.EMPTY;
              } else {
                isSearchVisible = !isSearchVisible;
              }
            });
          },
        ),
      ];
    } else {
      if (widget.enableSearch == true) {
        List<Widget> actions = [];
        actions.add(
          AppIconButton(
            iconButtonType: IconButtonType.search,
            onPress: () {
              setState(() {
                isSearchVisible = !isSearchVisible;
              });
            },
          ),
        );
        if (widget.actions != null) {
          for (var element in widget.actions!) {
            actions.add(element);
          }
        }
        return actions;
      } else {
        return widget.actions;
      }
    }
  }

  Widget _searchTextField() {
    return TextFormField(
      controller: widget.searchController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        border: InputBorder.none,
      ),
      autofocus: true,
    );
  }
}
