import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/modules/wine/data/model/wine_list_filter_model.dart';
import 'package:kevin/services/app_functions.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/buttons/app_button.dart';
import 'package:kevin/ui/widgets/form/app_form.dart';
import 'package:kevin/ui/widgets/form/app_multi_select_field.dart';
import 'package:kevin/ui/widgets/form/app_select_field.dart';
import '../data/model/wine_classification_model.dart';
import '../data/model/wine_variety_model.dart';

class WineFilterView extends StatefulWidget {
  final Function(WineListFilterModel) notifyWineFilterChanged;
  final List<WineVarietyModel> wineVarietyList;
  final List<WineClassificationModel> wineClassificationList;

  const WineFilterView({
    super.key,
    required this.notifyWineFilterChanged,
    required this.wineVarietyList,
    required this.wineClassificationList,
  });

  @override
  State<WineFilterView> createState() => _WineFilterViewState();
}

class _WineFilterViewState extends State<WineFilterView> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  final _formKey = GlobalKey<FormState>();
  late WineListFilterModel wineListFilterModel;
  late WineListOrderType? selectedWineListOrderType;

  @override
  void initState() {
    wineListFilterModel = appPreferences.getWineListFilter();
    selectedWineListOrderType = WineListOrderType.values.firstWhere((element) => element.getId() == wineListFilterModel.wineListOrderTypeId);
    super.initState();
  }

  void _onChangeFilter() {
    _calculateActiveFilters();
    appPreferences.setWineListFilter(wineListFilterModel);
    widget.notifyWineFilterChanged(wineListFilterModel);
  }

  void _calculateActiveFilters() {
    int sum = 0;
    if (wineListFilterModel.wineClassifications.isNotEmpty) {
      sum += 1;
    }
    if (wineListFilterModel.wineVarieties.isNotEmpty) {
      sum += 1;
    }
    if (selectedWineListOrderType != WineListOrderType.yearAsc) {
      sum += 1;
    }
    wineListFilterModel.activeFilters = sum;
  }

  void _onResetFilter() {
    // TODO Reset select box and take empty array.
    setState(() {
      wineListFilterModel = WineListFilterModel(
        activeFilters: 0,
        wineVarieties: [],
        wineClassifications: [],
        wineListOrderTypeId: WineListOrderType.yearAsc.getId(),
      );
      appPreferences.setWineListFilter(wineListFilterModel);
      widget.notifyWineFilterChanged(wineListFilterModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppForm(
      formKey: _formKey,
      content: [
        AppMultiSelectField<WineVarietyModel>(
          labelText: AppLocalizations.of(context)!.wineVarieties,
          items: widget.wineVarietyList,
          selectedItems: wineListFilterModel.wineVarieties,
          compareFn: (item, selectedItem) => item.id == selectedItem.id,
          itemAsString: (WineVarietyModel wineClassification) => appFormatTextWithCode(wineClassification.title, wineClassification.code),
          onChanged: (List<WineVarietyModel> wineVarieties) {
            setState(() {
              wineListFilterModel.wineVarieties = wineVarieties;
            });
            _onChangeFilter();
          },
        ),
        AppMultiSelectField(
          labelText: AppLocalizations.of(context)!.wineClassification,
          items: widget.wineClassificationList,
          selectedItems: wineListFilterModel.wineClassifications,
          compareFn: (item, selectedItem) => item.id == selectedItem.id,
          itemAsString: (WineClassificationModel wineClassification) => appFormatTextWithCode(wineClassification.title, wineClassification.code),
          onChanged: (List<WineClassificationModel> wineClassifications) {
            setState(() {
              wineListFilterModel.wineClassifications = wineClassifications;
            });
            _onChangeFilter();
          },
        ),
        AppSelectField(
          // TODO: make logic for sorting wineList.
          labelText: AppLocalizations.of(context)!.filterOrder,
          items: WineListOrderType.values,
          selectedItem: selectedWineListOrderType,
          compareFn: (item, selectedItem) => item.getId() == selectedItem.getId(),
          itemAsString: (WineListOrderType orderType) => appFormatTextWithDash(orderType.getTranslate(context), orderType.getSortTranslate(context)),
          onChanged: (WineListOrderType? orderType) {
            setState(() {
              selectedWineListOrderType = orderType;
              wineListFilterModel.wineListOrderTypeId = orderType!.getId();
            });
            _onChangeFilter();
          },
          showClearButton: false,
        ),
        AppButton(
          title: AppLocalizations.of(context)!.resetFilter,
          onTap: () {
            _onResetFilter();
          },
        ),
      ],
    );
  }
}
