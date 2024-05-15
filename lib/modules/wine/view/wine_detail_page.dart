import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/const/app_constant.dart';
import 'package:kevin/const/app_units.dart';
import 'package:kevin/modules/wine/bloc/wine_bloc.dart';
import 'package:kevin/modules/wine/bloc/wine_variety_bloc.dart';
import 'package:kevin/modules/wine/data/model/wine_classification_model.dart';
import 'package:kevin/modules/wine/data/model/wine_model.dart';
import 'package:kevin/modules/wine/data/model/wine_variety_model.dart';
import 'package:kevin/services/app_functions.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/form/app_form.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';
import 'package:kevin/ui/widgets/buttons/app_icon_button.dart';
import 'package:kevin/ui/widgets/form/app_multi_select_field.dart';
import 'package:kevin/ui/widgets/form/app_select_field.dart';
import 'package:kevin/ui/widgets/form/app_text_field.dart';

class WineDetailPage extends StatefulWidget {
  final List<WineClassificationModel> wineClassificationList;
  final List<WineVarietyModel> wineVarietyList;
  final WineModel? wineModel;
  const WineDetailPage({
    super.key,
    required this.wineClassificationList,
    required this.wineVarietyList,
    this.wineModel,
  });

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
  late WineModel? wineModel;
  late WineClassificationModel? selectedWineClassification;
  late List<WineVarietyModel> selectedWineVarieties;

  @override
  void initState() {
    BlocProvider.of<WineVarietyBloc>(context).add(WineVarietyListEvent());
    wineModel = null;
    selectedWineClassification = null;
    selectedWineVarieties = [];
    if (widget.wineModel != null) {
      wineModel = widget.wineModel;
      for (var element in wineModel!.wineVarieties) {
        selectedWineVarieties.add(element);
      }
      selectedWineClassification = wineModel!.wineClassification;
      _titleController.text = wineModel!.title ?? "";
      _quantityController.text = appFormatDoubleToString(wineModel!.quantity);
      _yearController.text = wineModel!.year.toString();
      _alcoholController.text = appFormatDoubleToString(wineModel!.alcohol);
      _acidController.text = appFormatDoubleToString(wineModel!.acid);
      _sugarController.text = appFormatDoubleToString(wineModel!.sugar);
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

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(wineModel != null ? wineModel!.title! : AppLocalizations.of(context)!.createWine),
      actions: [
        BlocConsumer<WineBloc, WineState>(
          listener: (context, state) {
            if (state is WineSaveSuccessState) {
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
    return AppForm(
      formKey: _formKey,
      content: <Widget>[
        AppTextField(
          controller: _titleController,
          label: AppLocalizations.of(context)!.title,
        ),
        AppMultiSelectField<WineVarietyModel>(
          labelText: AppLocalizations.of(context)!.wineVarieties,
          items: widget.wineVarietyList,
          selectedItems: selectedWineVarieties,
          compareFn: (item, selectedItem) => item.id == selectedItem.id,
          itemAsString: (WineVarietyModel wineClassification) => appFormatTextWithCode(wineClassification.title, wineClassification.code),
          onChanged: (List<WineVarietyModel> wineVarieties) {
            setState(() {
              selectedWineVarieties = wineVarieties;
            });
          },
          validate: true,
          showSearchBox: true,
        ),
        AppSelectField(
          labelText: AppLocalizations.of(context)!.wineClassification,
          items: widget.wineClassificationList,
          selectedItem: selectedWineClassification,
          compareFn: (item, selectedItem) => item.id == selectedItem.id,
          itemAsString: (WineClassificationModel wineClassification) =>
              appFormatTextWithCode(wineClassification.title, wineClassification.code),
          onChanged: (WineClassificationModel? wineClassification) {
            setState(() {
              selectedWineClassification = wineClassification;
            });
          },
        ),
        AppTextField(
          controller: _quantityController,
          label: AppLocalizations.of(context)!.wineQuantity,
          isRequired: true,
          inputType: InputType.double,
          keyboardType: TextInputType.number,
          unit: AppUnits().liter(_quantityController.text, context),
        ),
        AppTextField(
          controller: _yearController,
          label: AppLocalizations.of(context)!.year,
          isRequired: true,
          inputType: InputType.double,
          keyboardType: TextInputType.number,
        ),
        AppTextField(
          controller: _alcoholController,
          label: AppLocalizations.of(context)!.alcohol,
          inputType: InputType.double,
          keyboardType: TextInputType.number,
          unit: AppUnits.percent,
        ),
        AppTextField(
          controller: _acidController,
          label: AppLocalizations.of(context)!.acid,
          inputType: InputType.double,
          keyboardType: TextInputType.number,
          unit: AppUnits.gramPerLiter,
        ),
        AppTextField(
          controller: _sugarController,
          label: AppLocalizations.of(context)!.sugar,
          inputType: InputType.double,
          keyboardType: TextInputType.number,
          unit: AppUnits.gramPerLiter,
        ),
        AppTextField(
          controller: _noteController,
          label: AppLocalizations.of(context)!.note,
          inputType: InputType.note,
        ),
      ],
    );
  }
}
