import 'package:flutter/material.dart';
import 'package:kevin/const/app_constant.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/buttons/app_icon_button.dart';
import 'package:kevin/ui/widgets/buttons/app_filter_icon_button.dart';
import 'package:kevin/ui/widgets/widget_model/filter_model.dart';

import 'app_modal_view.dart';

class AppSearchBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  // if enableSearch is true, searchController must is required too
  final bool? enableSearch;
  final TextEditingController? searchController;
  final FilterModel? filterModel;

  const AppSearchBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.enableSearch,
    this.searchController,
    this.filterModel,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _AppSearchBarState extends State<AppSearchBar> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  bool isSearchVisible = false;
  bool isFilterVisible = false;

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
      List<Widget> actions = [];
      if (widget.filterModel?.isFilterActive == true) {
        actions.add(
          AppFilterIconButton(
            number: widget.filterModel!.activeFilters,
            onPress: () {
              appShowModal(
                context: context,
                title: widget.filterModel!.title,
                content: widget.filterModel!.filterBody,
              );
            },
          ),
        );
      }

      if (widget.enableSearch == true) {
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
      }
      if (widget.actions != null) {
        for (var element in widget.actions!) {
          actions.add(element);
        }
      }
      return actions;
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
