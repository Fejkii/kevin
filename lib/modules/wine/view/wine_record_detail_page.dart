import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/wine/bloc/wine_record_bloc.dart';
import 'package:kevin/modules/wine/data/model/wine_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/ui/widgets/app_box_content.dart';
import 'package:kevin/ui/widgets/app_form.dart';
import 'package:kevin/ui/widgets/texts/app_text_field.dart';

import '../../../const/app_units.dart';
import '../../../services/app_functions.dart';
import '../../../services/app_preferences.dart';
import '../../../services/dependency_injection.dart';
import '../../../ui/widgets/app_date_picker.dart';
import '../../../ui/widgets/app_loading_indicator.dart';
import '../../../ui/widgets/app_scaffold.dart';
import '../../../ui/widgets/app_toast_messages.dart';
import '../../../ui/widgets/buttons/app_icon_button.dart';
import '../../../ui/widgets/texts/app_text_with_value.dart';
import '../data/model/wine_record_model.dart';

class WineRecordDetailPage extends StatefulWidget {
  final WineModel wineModel;
  final WineRecordModel? wineRecord;
  const WineRecordDetailPage({
    Key? key,
    required this.wineModel,
    this.wineRecord,
  }) : super(key: key);

  @override
  State<WineRecordDetailPage> createState() => _WineRecordDetailPageState();
}

class _WineRecordDetailPageState extends State<WineRecordDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _freeSulfureController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dateToController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _requiredSulphurisationController = TextEditingController();
  final TextEditingController _liquidSulfurController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AppPreferences appPreferences = instance<AppPreferences>();

  late String wineId;
  late WineRecordModel? wineRecord;
  late WineRecordType? selectedWineRecordType;
  late List<WineRecordType> wineRecordTypeList;
  late bool _isInProgress;

  double sulfirizationBy = 0;
  double dosage = 0;
  String title = "";

  @override
  void initState() {
    wineRecordTypeList = WineRecordType.values.map((e) => e).toList();
    wineId = widget.wineModel.id;
    wineRecord = null;
    selectedWineRecordType = null;
    _requiredSulphurisationController.text = appFormatDoubleToString(appPreferences.getUserProject().project.defaultFreeSulfur);
    _liquidSulfurController.text = appFormatDoubleToString(appPreferences.getUserProject().project.defaultLiquidSulfur);
    _quantityController.text = widget.wineModel.quantity.toStringAsFixed(0);
    _isInProgress = false;

    if (widget.wineRecord != null) {
      wineRecord = widget.wineRecord;
      selectedWineRecordType = WineRecordType.values.firstWhere((wrt) => wrt.getId() == wineRecord!.wineRecordTypeId);
      _noteController.text = wineRecord!.note ?? "";
      _titleController.text = wineRecord!.title ?? "";

      if (wineRecord!.wineRecordTypeId == WineRecordType.measurementFreeSulfure.getId()) {
        double freeSulfure = WineRecordFreeSulfure.fromJson(wineRecord!.data).freeSulfure;
        double quantity = WineRecordFreeSulfure.fromJson(wineRecord!.data).quantity;
        double requiredSulphurisation = WineRecordFreeSulfure.fromJson(wineRecord!.data).requiredSulphurisation;
        double liquidSulfur = WineRecordFreeSulfure.fromJson(wineRecord!.data).liquidSulfur;
        _freeSulfureCalculate(quantity, freeSulfure, requiredSulphurisation, liquidSulfur);
        _quantityController.text = quantity.toStringAsFixed(0);
        _freeSulfureController.text = freeSulfure.toStringAsFixed(0);
        _requiredSulphurisationController.text = requiredSulphurisation.toStringAsFixed(0);
        _liquidSulfurController.text = liquidSulfur.toStringAsFixed(0);
      }

      if (wineRecord!.wineRecordTypeId == WineRecordType.fermentation.getId()) {
        _dateToController.text = wineRecord!.dateTo != null ? wineRecord!.dateTo!.toIso8601String() : "";
        _isInProgress = wineRecord!.isInProgress != null ? wineRecord!.isInProgress! : false;
      }
    }

    _freeSulfureListener(_quantityController);
    _freeSulfureListener(_freeSulfureController);
    _freeSulfureListener(_requiredSulphurisationController);
    _freeSulfureListener(_liquidSulfurController);

    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _dateToController.dispose();
    _noteController.dispose();
    _titleController.dispose();
    _freeSulfureController.dispose();
    _requiredSulphurisationController.dispose();
    _liquidSulfurController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _freeSulfureListener(TextEditingController controller) {
    controller.addListener(() {
      setState(() {
        if (_quantityController.text != "" &&
            _freeSulfureController.text != "" &&
            _requiredSulphurisationController.text != "" &&
            _liquidSulfurController.text != "") {
          _freeSulfureCalculate(
            double.parse(_quantityController.text),
            double.parse(_freeSulfureController.text),
            double.parse(_requiredSulphurisationController.text),
            double.parse(_liquidSulfurController.text),
          );
        } else {
          sulfirizationBy = 0;
          dosage = 0;
        }
      });
    });
  }

  void _freeSulfureCalculate(double quantity, double measuredSulfure, double requiredSulphurisation, double liquidSulfur) {
    double sulfirization = requiredSulphurisation - measuredSulfure;
    sulfirizationBy = sulfirization > 0 ? sulfirization : 0;
    dosage = quantity * (0.01 * sulfirizationBy) * (10 / liquidSulfur);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _form(context),
      appBar: _appBar(context),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(wineRecord != null ? selectedWineRecordType!.getTranslate(context) : AppLocalizations.of(context)!.addRecord),
      actions: [
        BlocConsumer<WineRecordBloc, WineRecordState>(
          listener: (context, state) {
            if (state is WineRecordSuccessState) {
              setState(() {
                wineRecord != null
                    ? AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updatedSuccessfully, ToastState.success)
                    : AppToastMessage().showToastMsg(AppLocalizations.of(context)!.createdSuccessfully, ToastState.success);
              });
              Navigator.pop(context);
            } else if (state is WineRecordFailureState) {
              AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
            }
          },
          builder: (context, state) {
            if (state is WineRecordLoadingState) {
              return const AppLoadingIndicator();
            } else {
              return AppIconButton(
                iconButtonType: IconButtonType.save,
                onPress: () {
                  if (_formKey.currentState!.validate()) {
                    String data = "";
                    if (WineRecordType.measurementFreeSulfure == selectedWineRecordType) {
                      _titleController.text = "";
                      data = WineRecordFreeSulfure(
                        freeSulfure: double.parse(_freeSulfureController.text),
                        quantity: widget.wineModel.quantity,
                        requiredSulphurisation: double.parse(_requiredSulphurisationController.text),
                        liquidSulfur: double.parse(_liquidSulfurController.text),
                        sulfurizationBy: sulfirizationBy,
                        liquidSulfurDosage: double.parse(dosage.toStringAsFixed(2)),
                      ).toJson();
                    }
                    if (wineRecord != null) {
                      BlocProvider.of<WineRecordBloc>(context).add(
                        UpdateWineRecordEvent(
                          wineId: wineId,
                          wineRecordModel: WineRecordModel(
                              id: wineRecord!.id,
                              wineRecordTypeId: selectedWineRecordType!.getId(),
                              date: appToDateTime(_dateController.text.trim()),
                              isInProgress: _isInProgress,
                              dateTo: _dateToController.text != "" ? appToDateTime(_dateToController.text.trim()) : null,
                              title: _titleController.text.trim(),
                              data: data,
                              note: _noteController.text.trim(),
                              created: wineRecord!.created),
                        ),
                      );
                    } else {
                      BlocProvider.of<WineRecordBloc>(context).add(
                        CreateWineRecordEvent(
                          wineId,
                          WineRecordModel(
                            wineRecordTypeId: selectedWineRecordType!.getId(),
                            date: appToDateTime(_dateController.text.trim()),
                            isInProgress: _isInProgress,
                            dateTo: _dateToController.text != "" ? appToDateTime(_dateToController.text.trim()) : null,
                            title: _titleController.text.trim(),
                            data: data,
                            note: _noteController.text.trim(),
                            created: DateTime.now(),
                          ),
                        ),
                      );
                    }
                  }
                },
              );
            }
          },
        ),
      ],
    );
  }

  Widget _form(BuildContext context) {
    return AppForm(
      formKey: _formKey,
      content: <Widget>[
        AppDatePicker(
          controller: _dateController,
          initDate: wineRecord?.date,
          fillTodayDate: true,
          setIcon: true,
        ),
        DropdownSearch<WineRecordType>(
          popupProps: const PopupProps.menu(showSelectedItems: false, showSearchBox: true),
          items: wineRecordTypeList,
          itemAsString: (WineRecordType wrt) => wrt.getTranslate(context),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.all(10),
              labelText: AppLocalizations.of(context)!.wineRecordType,
              hintText: AppLocalizations.of(context)!.selectInSelectBox,
            ),
          ),
          onChanged: (WineRecordType? value) {
            setState(() {
              selectedWineRecordType = value;
            });
          },
          validator: (WineRecordType? item) {
            if (item == null) return AppLocalizations.of(context)!.inputEmpty;
            return null;
          },
          autoValidateMode: AutovalidateMode.onUserInteraction,
          selectedItem: selectedWineRecordType,
          clearButtonProps: const ClearButtonProps(isVisible: true),
        ),
        _freeSulfure(),
        _fermentation(),
        _otherRecord(),
        AppTextField(
          controller: _noteController,
          label: AppLocalizations.of(context)!.note,
          inputType: InputType.note,
        ),
        _otherInfo(),
      ],
    );
  }

  Widget _otherInfo() {
    if (widget.wineRecord != null) {
      return AppTextWithValue(text: AppLocalizations.of(context)!.created, value: appFormatDateTime(widget.wineRecord!.created, dateOnly: false));
    } else {
      return Container();
    }
  }

  Widget _freeSulfure() {
    if (selectedWineRecordType != null) {
      return selectedWineRecordType == WineRecordType.measurementFreeSulfure
          ? Column(
              children: [
                AppTextField(
                  controller: _freeSulfureController,
                  label: AppLocalizations.of(context)!.measuredFreeSulfur,
                  isRequired: true,
                  inputType: InputType.double,
                  unit: AppUnits.miliGramPerLiter,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: AppTextWithValue(
                        text: AppLocalizations.of(context)!.wineQuantity,
                        value: "",
                      ),
                    ),
                    Flexible(
                      child: AppTextField(
                          controller: _quantityController,
                          isRequired: true,
                          label: "",
                          keyboardType: TextInputType.number,
                          unit: AppUnits().liter(_quantityController.text, context)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: AppTextWithValue(
                        text: AppLocalizations.of(context)!.requiredSulphurisation,
                        value: "",
                      ),
                    ),
                    Flexible(
                      child: AppTextField(
                        controller: _requiredSulphurisationController,
                        isRequired: true,
                        label: "",
                        unit: AppUnits.miliGramPerLiter,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: AppTextWithValue(
                        text: AppLocalizations.of(context)!.liquidSulfur,
                        value: "",
                      ),
                    ),
                    Flexible(
                      child: AppTextField(
                        controller: _liquidSulfurController,
                        isRequired: true,
                        label: "",
                        keyboardType: TextInputType.number,
                        unit: AppUnits.percent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                AppBoxContent(
                  child: Column(
                    children: [
                      AppTextWithValue(
                        text: AppLocalizations.of(context)!.sulfurizationBy,
                        value: sulfirizationBy.toStringAsFixed(0),
                        unit: AppUnits.miliGramPerLiter,
                      ),
                      AppTextWithValue(
                        text: AppLocalizations.of(context)!.liquidSulfurDosage,
                        value: dosage.toStringAsFixed(1),
                        unit: AppUnits.miliLiter,
                      ),
                    ],
                  ),
                )
              ],
            )
          : Container();
    } else {
      return Container();
    }
  }

  Widget _fermentation() {
    if (selectedWineRecordType != null) {
      return selectedWineRecordType == WineRecordType.fermentation
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.inProgress),
                    Switch(
                      value: _isInProgress,
                      onChanged: (value) {
                        setState(() {
                          _isInProgress = !_isInProgress;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AppDatePicker(
                  controller: _dateToController,
                  label: AppLocalizations.of(context)!.dateTo,
                  initDate: wineRecord?.dateTo,
                  fillTodayDate: false,
                  setIcon: true,
                ),
              ],
            )
          : Container();
    } else {
      return Container();
    }
  }

  // TODO: Bug s přepínáním Typu síry/ síření, měření atd...

  Widget _otherRecord() {
    if (selectedWineRecordType != null) {
      return selectedWineRecordType == WineRecordType.others
          ? AppTextField(
              controller: _titleController,
              label: AppLocalizations.of(context)!.title,
              isRequired: true,
              inputType: InputType.title,
            )
          : Container();
    } else {
      return Container();
    }
  }
}
