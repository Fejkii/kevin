import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppMultiSelectField<T> extends StatelessWidget {
  final String labelText;
  final List<T> items;
  final List<T> selectedItems;
  final DropdownSearchCompareFn<T> compareFn;
  final DropdownSearchItemAsString<T> itemAsString;
  final ValueChanged<List<T>> onChanged;
  final bool showClearButton;
  final bool showSearchBox;
  final bool validate;

  const AppMultiSelectField({
    super.key,
    required this.labelText,
    required this.items,
    required this.selectedItems,
    required this.compareFn,
    required this.itemAsString,
    required this.onChanged,
    this.showClearButton = true,
    this.showSearchBox = false,
    this.validate = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>.multiSelection(
      items: items,
      itemAsString: itemAsString,
      compareFn: compareFn,
      onChanged: onChanged,
      selectedItems: selectedItems,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(6),
          labelText: labelText,
          hintText: AppLocalizations.of(context)!.selectInSelectBox,
        ),
      ),
      popupProps: PopupPropsMultiSelection.menu(
        showSearchBox: showSearchBox,
        searchDelay: const Duration(seconds: 0),
        fit: FlexFit.loose,
      ),
      clearButtonProps: ClearButtonProps(isVisible: showClearButton),
      validator: validate
          ? (List<T>? items) {
              if (items == null || items.isEmpty) return AppLocalizations.of(context)!.inputEmpty;
              return null;
            }
          : null,
      autoValidateMode: validate ? AutovalidateMode.onUserInteraction : null,
    );
  }
}
