import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/modules/vineyard/bloc/vineyard_bloc.dart';
import 'package:kevin/modules/vineyard/bloc/vineyard_record_bloc.dart';
import 'package:kevin/ui/widgets/app_form.dart';
import 'package:kevin/ui/widgets/texts/app_content_text.dart';
import 'package:kevin/ui/widgets/texts/app_subtitle_text.dart';

import '../../../services/app_functions.dart';
import '../../../services/app_preferences.dart';
import '../../../services/dependency_injection.dart';
import '../../../ui/widgets/app_date_picker.dart';
import '../../../ui/widgets/app_loading_indicator.dart';
import '../../../ui/widgets/app_scaffold.dart';
import '../../../ui/widgets/app_toast_messages.dart';
import '../../../ui/widgets/buttons/app_icon_button.dart';
import '../../../ui/widgets/texts/app_text_field.dart';
import '../model/vineyard_model.dart';
import '../model/vineyard_record_model.dart';

class VineyardRecordDetailPage extends StatefulWidget {
  final VineyardModel vineyardModel;
  final VineyardRecordModel? vineyardRecordModel;
  const VineyardRecordDetailPage({
    Key? key,
    required this.vineyardModel,
    this.vineyardRecordModel,
  }) : super(key: key);

  @override
  State<VineyardRecordDetailPage> createState() => _VineyardRecordDetailPageState();
}

class _VineyardRecordDetailPageState extends State<VineyardRecordDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dateToController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _sprayNameController = TextEditingController();
  final TextEditingController _amountSprayController = TextEditingController();
  final TextEditingController _amountWaterController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AppPreferences appPreferences = instance<AppPreferences>();

  late VineyardModel vineyardModel;
  late VineyardRecordModel? vineyardRecordModel;
  late VineyardRecordType? selectedVineyardRecordType;
  late List<VineyardRecordType> vineyardRecordTypeList;

  @override
  void initState() {
    vineyardRecordTypeList = VineyardRecordType.values.map((e) => e).toList();
    vineyardModel = widget.vineyardModel;
    vineyardRecordModel = null;
    selectedVineyardRecordType = null;

    if (widget.vineyardRecordModel != null) {
      vineyardRecordModel = widget.vineyardRecordModel;
      selectedVineyardRecordType = VineyardRecordType.values.firstWhere((wrt) => wrt.getId() == vineyardRecordModel!.vineyardRecordTypeId);
      _titleController.text = vineyardRecordModel!.title ?? "";
      _dateController.text = vineyardRecordModel!.date.toIso8601String();
      _noteController.text = vineyardRecordModel!.note ?? "";
      if (vineyardRecordModel!.vineyardRecordTypeId == VineyardRecordType.spraying.getId()) {
        _sprayNameController.text = VineyardRecordSpraying.fromJson(vineyardRecordModel!.data).sprayName;
        _amountSprayController.text = VineyardRecordSpraying.fromJson(vineyardRecordModel!.data).amountSpray.toStringAsFixed(0);
        _amountWaterController.text = VineyardRecordSpraying.fromJson(vineyardRecordModel!.data).amountWater.toStringAsFixed(0);
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _dateToController.dispose();
    _noteController.dispose();
    _sprayNameController.dispose();
    _amountSprayController.dispose();
    _amountWaterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _form(context),
      appBar: AppBar(
        title: Text(vineyardRecordModel != null ? selectedVineyardRecordType!.getTranslate(context) : AppLocalizations.of(context)!.addRecord),
        actions: [
          BlocConsumer<VineyardRecordBloc, VineyardRecordState>(
            listener: (context, state) {
              if (state is VineyardRecordSuccessState) {
                setState(() {
                  vineyardRecordModel != null
                      ? AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updatedSuccessfully, ToastState.success)
                      : AppToastMessage().showToastMsg(AppLocalizations.of(context)!.createdSuccessfully, ToastState.success);
                });
                Navigator.pop(context);
              } else if (state is VineyardRecordFailureState) {
                AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
              }
            },
            builder: (context, state) {
              if (state is VineyardLoadingState) {
                return const AppLoadingIndicator();
              } else {
                return AppIconButton(
                  iconButtonType: IconButtonType.save,
                  onPress: () {
                    if (_formKey.currentState!.validate()) {
                      String data = "";
                      if (VineyardRecordType.spraying == selectedVineyardRecordType) {
                        _titleController.text = "";
                        data = VineyardRecordSpraying(
                          sprayName: _sprayNameController.text,
                          amountSpray: double.parse(_amountSprayController.text),
                          amountWater: double.parse(_amountWaterController.text),
                        ).toJson();
                      }

                      final vineyardRecord = VineyardRecordModel(
                        id: vineyardRecordModel?.id,
                        vineyardRecordTypeId: selectedVineyardRecordType!.getId(),
                        date: appToDateTime(_dateController.text.trim()),
                        data: data,
                        created: DateTime.now(),
                      );

                      vineyardRecordModel != null
                          ? BlocProvider.of<VineyardRecordBloc>(context).add(UpdateVineyardRecordEvent(vineyardModel.id!, vineyardRecord))
                          : BlocProvider.of<VineyardRecordBloc>(context).add(CreateVineyardRecordEvent(vineyardModel.id!, vineyardRecord));
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _form(BuildContext context) {
    return AppForm(
      formKey: _formKey,
      content: <Widget>[
        AppDatePicker(
          controller: _dateController,
          initDate: vineyardRecordModel?.date,
          setIcon: true,
        ),
        DropdownSearch<VineyardRecordType>(
          popupProps: const PopupProps.menu(showSelectedItems: false, showSearchBox: true),
          items: vineyardRecordTypeList,
          itemAsString: (VineyardRecordType vrt) => vrt.getTranslate(context),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.all(10),
              labelText: AppLocalizations.of(context)!.vineyardRecordType,
              hintText: AppLocalizations.of(context)!.selectInSelectBox,
            ),
          ),
          onChanged: (VineyardRecordType? value) {
            setState(() {
              selectedVineyardRecordType = value;
              print(value);
            });
          },
          selectedItem: selectedVineyardRecordType,
          clearButtonProps: const ClearButtonProps(isVisible: true),
        ),
        _sprayingRecord(),
        _otherRecord(),
        AppTextField(
          controller: _noteController,
          label: AppLocalizations.of(context)!.note,
          inputType: InputType.note,
        ),
      ],
    );
  }

  Widget _sprayingRecord() {
    if (selectedVineyardRecordType != null) {
      return selectedVineyardRecordType == VineyardRecordType.spraying
          ? Column(
              children: [
                AppTextField(
                  controller: _sprayNameController,
                  label: AppLocalizations.of(context)!.sprayName,
                  isRequired: true,
                  inputType: InputType.title,
                ),
                const SizedBox(height: 20),
                AppSubTitleText(text: AppLocalizations.of(context)!.ratio),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: AppTextField(
                        controller: _amountSprayController,
                        label: AppLocalizations.of(context)!.spray,
                        isRequired: true,
                        inputType: InputType.integer,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const AppContentText(
                      text: "/",
                      size: 25,
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: AppTextField(
                        controller: _amountWaterController,
                        label: AppLocalizations.of(context)!.water,
                        isRequired: true,
                        inputType: InputType.integer,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Container();
    } else {
      return Container();
    }
  }

  Widget _otherRecord() {
    if (selectedVineyardRecordType != null) {
      return selectedVineyardRecordType == VineyardRecordType.others
          ? Column(
              children: [
                AppTextField(
                  controller: _titleController,
                  label: AppLocalizations.of(context)!.title,
                  isRequired: true,
                  inputType: InputType.title,
                ),
              ],
            )
          : Container();
    } else {
      return Container();
    }
  }
}
