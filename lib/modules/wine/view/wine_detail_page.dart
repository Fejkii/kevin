import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/const/app_units.dart';
import 'package:kevin/const/app_values.dart';
import 'package:kevin/modules/wine/bloc/wine_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/modules/wine/bloc/wine_variety_bloc.dart';
import 'package:kevin/modules/wine/data/model/wine_classification_model.dart';
import 'package:kevin/modules/wine/data/model/wine_model.dart';
import 'package:kevin/modules/wine/data/model/wine_variety_model.dart';
import 'package:kevin/services/app_functions.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';
import 'package:kevin/ui/widgets/buttons/app_icon_button.dart';
import 'package:kevin/ui/widgets/texts/app_text_field.dart';
import 'package:kevin/ui/widgets/texts/app_text_with_code.dart';

class WineDetailPage extends StatefulWidget {
  final WineModel? wineModel;
  const WineDetailPage({
    Key? key,
    this.wineModel,
  }) : super(key: key);

  @override
  State<WineDetailPage> createState() => _WineDetailPageState();
}

class _WineDetailPageState extends State<WineDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _alcoholController = TextEditingController();
  final TextEditingController _acidController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AppPreferences appPreferences = instance<AppPreferences>();
  late List<WineClassificationModel> wineClassificationList;
  late List<WineVarietyModel> wineVarietiesList;
  late WineModel? wineModel;
  late WineClassificationModel? selectedWineClassification;
  late List<WineVarietyModel> selectedWineVarieties;

  @override
  void initState() {
    BlocProvider.of<WineVarietyBloc>(context).add(WineVarietyListEvent());
    wineClassificationList = appPreferences.getWineClassificationList();
    wineModel = null;
    wineVarietiesList = [];
    selectedWineClassification = null;
    selectedWineVarieties = [];
    if (widget.wineModel != null) {
      wineModel = widget.wineModel;
      for (var element in wineModel!.wineVarieties) {
        selectedWineVarieties.add(element);
      }
      selectedWineClassification = wineModel!.wineClassification;
      _titleController.text = wineModel!.title;
      _quantityController.text = parseDouble(wineModel!.quantity);
      _yearController.text = wineModel!.year.toString();
      _alcoholController.text = parseDouble(wineModel!.alcohol);
      _acidController.text = parseDouble(wineModel!.acid);
      _sugarController.text = parseDouble(wineModel!.sugar);
      _noteController.text = wineModel!.note ?? "";
    }

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    _yearController.dispose();
    _alcoholController.dispose();
    _acidController.dispose();
    _sugarController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _body(),
      appBar: _appBar(context),
    );
  }

  Widget _body() {
    return BlocProvider(
      create: (context) => WineBloc(),
      child: BlocConsumer<WineVarietyBloc, WineVarietyState>(
        listener: (context, state) {
          if (state is WineVarietyListSuccessState) {
            wineVarietiesList = state.wineVarietyList;
          } else if (state is WineVarietyFailureState) {
            AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
          }
        },
        builder: (context, state) {
          if (state is WineVarietyLoadingState) {
            return const AppLoadingIndicator();
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                _form(context),
                const SizedBox(height: 20),
                _otherInfo(),
                const SizedBox(height: 20),
              ],
            );
          }
        },
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(wineModel != null ? wineModel!.title : AppLocalizations.of(context)!.createWine),
      actions: [
        BlocConsumer<WineBloc, WineState>(
          listener: (context, state) {
            if (state is WineSuccessState) {
              wineModel != null
                  ? AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updatedSuccessfully, ToastState.success)
                  : AppToastMessage().showToastMsg(AppLocalizations.of(context)!.createdSuccessfully, ToastState.success);
              Navigator.pop(context);
            } else if (state is WineFailureState) {
              AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
            }
          },
          builder: (context, state) {
            if (state is WineLoadingState) {
              return const AppLoadingIndicator();
            } else {
              return AppIconButton(
                iconButtonType: IconButtonType.save,
                onPress: (() {
                  if (_formKey.currentState!.validate()) {
                    wineModel != null
                        ? BlocProvider.of<WineBloc>(context).add(
                            UpdateWineEvent(
                              wineModel: WineModel(
                                id: wineModel!.id,
                                projectId: wineModel!.projectId,
                                wineVarieties: selectedWineVarieties,
                                wineClassification: selectedWineClassification,
                                title: _titleController.text.trim(),
                                quantity: double.parse(_quantityController.text.trim()),
                                year: int.parse(_yearController.text.trim()),
                                alcohol: double.tryParse(_alcoholController.text.trim()),
                                acid: double.tryParse(_acidController.text.trim()),
                                sugar: double.tryParse(_sugarController.text.trim()),
                                note: _noteController.text.trim(),
                                created: wineModel!.created,
                                updated: DateTime.now(),
                              ),
                            ),
                          )
                        : BlocProvider.of<WineBloc>(context).add(
                            CreateWineEvent(
                              _titleController.text.trim(),
                              selectedWineVarieties,
                              selectedWineClassification,
                              double.parse(_quantityController.text.trim()),
                              int.parse(_yearController.text.trim()),
                              double.tryParse(_alcoholController.text.trim()),
                              double.tryParse(_acidController.text.trim()),
                              double.tryParse(_sugarController.text.trim()),
                              _noteController.text.trim(),
                            ),
                          );
                  }
                }),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _otherInfo() {
    if (wineModel != null) {
      return Column(
        children: [
          Text("${AppLocalizations.of(context)!.created}: ${appFormatDateTime(wineModel!.created)}"),
          Text(
              wineModel!.updated != null ? "${AppLocalizations.of(context)!.updated}: ${appFormatDateTime(wineModel!.updated!)}" : AppConstant.EMPTY),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppTextField(
            controller: _titleController,
            label: AppLocalizations.of(context)!.title,
            isRequired: true,
          ),
          const SizedBox(height: 20),
          DropdownSearch<WineVarietyModel>.multiSelection(
            popupProps: const PopupPropsMultiSelection.menu(
              showSelectedItems: true,
              interceptCallBacks: true,
              showSearchBox: true,
              constraints: BoxConstraints(maxHeight: 500),
            ),
            items: wineVarietiesList,
            itemAsString: (WineVarietyModel wineVariety) => AppTextWithCode().textWithCode(wineVariety.title, wineVariety.code),
            compareFn: (item, selectedItem) => item.id == selectedItem.id,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.wineVarieties,
                hintText: AppLocalizations.of(context)!.selectInSelectBox,
              ),
            ),
            onChanged: (List<WineVarietyModel> wineVarieties) {
              setState(() {
                selectedWineVarieties = wineVarieties;
              });
            },
            selectedItems: selectedWineVarieties,
            validator: (List<WineVarietyModel>? items) {
              if (items == null || items.isEmpty) return AppLocalizations.of(context)!.inputEmpty;
              return null;
            },
            autoValidateMode: AutovalidateMode.onUserInteraction,
            clearButtonProps: const ClearButtonProps(isVisible: true),
          ),
          const SizedBox(height: 20),
          DropdownSearch<WineClassificationModel>(
            popupProps: const PopupProps.menu(showSearchBox: true),
            items: wineClassificationList,
            itemAsString: (WineClassificationModel wineClassification) =>
                AppTextWithCode().textWithCode(wineClassification.title, wineClassification.code),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(10),
                labelText: AppLocalizations.of(context)!.wineClassification,
                hintText: AppLocalizations.of(context)!.selectInSelectBox,
              ),
            ),
            onChanged: (WineClassificationModel? wineClassification) {
              setState(() {
                selectedWineClassification = wineClassification;
              });
            },
            selectedItem: selectedWineClassification,
            clearButtonProps: const ClearButtonProps(isVisible: true),
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _quantityController,
            label: AppLocalizations.of(context)!.wineQuantity,
            isRequired: true,
            inputType: InputType.double,
            keyboardType: TextInputType.number,
            unit: AppUnits().liter(_quantityController.text, context),
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _yearController,
            label: AppLocalizations.of(context)!.year,
            isRequired: true,
            inputType: InputType.double,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _alcoholController,
            label: AppLocalizations.of(context)!.alcohol,
            inputType: InputType.double,
            keyboardType: TextInputType.number,
            unit: AppUnits.percent,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _acidController,
            label: AppLocalizations.of(context)!.acid,
            inputType: InputType.double,
            keyboardType: TextInputType.number,
            unit: AppUnits.gramPerLiter,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _sugarController,
            label: AppLocalizations.of(context)!.sugar,
            inputType: InputType.double,
            keyboardType: TextInputType.number,
            unit: AppUnits.gramPerLiter,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _noteController,
            label: AppLocalizations.of(context)!.note,
            inputType: InputType.note,
          ),
        ],
      ),
    );
  }
}
