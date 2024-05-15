import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppSelectField<T> extends StatelessWidget {
  final String labelText;
  final List<T> items;
  final T? selectedItem;
  final DropdownSearchCompareFn<T> compareFn;
  final DropdownSearchItemAsString<T> itemAsString;
  final ValueChanged<T?>? onChanged;
  final bool showClearButton;
  final bool showSearchBox;
  final bool validate;
  const AppSelectField({
    super.key,
    required this.labelText,
    required this.items,
    required this.selectedItem,
    required this.compareFn,
    required this.itemAsString,
    required this.onChanged,
    this.showClearButton = true,
    this.showSearchBox = false,
    this.validate = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: items,
      itemAsString: itemAsString,
      onChanged: onChanged,
      selectedItem: selectedItem,
      compareFn: compareFn,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(10),
          labelText: labelText,
          hintText: AppLocalizations.of(context)!.selectInSelectBox,
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: showSearchBox,
        searchDelay: const Duration(seconds: 0),
      ),
      clearButtonProps: ClearButtonProps(isVisible: showClearButton),
      validator: validate
          ? (T? items) {
              if (items == null) return AppLocalizations.of(context)!.inputEmpty;
              return null;
            }
          : null,
      autoValidateMode: validate ? AutovalidateMode.onUserInteraction : null,
    );
  }
}
