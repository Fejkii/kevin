// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/ui/widgets/form/app_form.dart';

import '../../../services/app_preferences.dart';
import '../../../services/dependency_injection.dart';
import '../../../ui/widgets/app_loading_indicator.dart';
import '../../../ui/widgets/app_scaffold.dart';
import '../../../ui/widgets/app_toast_messages.dart';
import '../../../ui/widgets/buttons/app_icon_button.dart';
import '../../../ui/widgets/form/app_text_field.dart';
import '../../wine/bloc/wine_variety_bloc.dart';
import '../../wine/data/model/wine_variety_model.dart';
import '../bloc/vineyard_wine_bloc.dart';
import '../model/vineyard_wine_model.dart';

class VineyardWineDetailPage extends StatefulWidget {
  final String vineyardId;
  final VineyardWineModel? vineyardWineModel;
  const VineyardWineDetailPage({
    super.key,
    required this.vineyardId,
    this.vineyardWineModel,
  });

  @override
  State<VineyardWineDetailPage> createState() => _VineyardWineDetailPageState();
}

class _VineyardWineDetailPageState extends State<VineyardWineDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AppPreferences appPreferences = instance<AppPreferences>();

  late String vineyardId;
  late String title = "";
  late VineyardWineModel? vineyardWine;
  late WineVarietyModel? selectedWineVariety;
  late List<WineVarietyModel> wineVareityList;

  @override
  void initState() {
    wineVareityList = [];
    vineyardId = widget.vineyardId;
    selectedWineVariety = null;
    vineyardWine = null;
    if (widget.vineyardWineModel != null) {
      vineyardWine = widget.vineyardWineModel!;
      selectedWineVariety = vineyardWine!.wineModel;
      _titleController.text = vineyardWine!.title ?? "";
      _quantityController.text = vineyardWine!.quantity.toString();
      _yearController.text = vineyardWine!.year != null ? vineyardWine!.year.toString() : "";
      _noteController.text = vineyardWine!.note ?? "";
      if (vineyardWine!.title != "") {
        title = vineyardWine!.title!;
      } else {
        title = vineyardWine!.wineModel.title;
      }
    }
    super.initState();
    BlocProvider.of<WineVarietyBloc>(context).add(WineVarietyListEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _form(context),
      appBar: AppBar(
        title: Text(title != "" ? title : AppLocalizations.of(context)!.addRecord),
        actions: [
          BlocConsumer<VineyardWineBloc, VineyardWineState>(
            listener: (context, state) {
              if (state is VineyardWineSuccessState) {
                setState(() {
                  vineyardWine != null
                      ? AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updatedSuccessfully, ToastState.success)
                      : AppToastMessage().showToastMsg(AppLocalizations.of(context)!.createdSuccessfully, ToastState.success);
                });
                Navigator.pop(context);
              } else if (state is VineyardWineFailureState) {
                AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
              }
            },
            builder: (context, state) {
              if (state is VineyardWineLoadingState) {
                return const AppLoadingIndicator();
              } else {
                return AppIconButton(
                  iconButtonType: IconButtonType.save,
                  onPress: () {
                    if (_formKey.currentState!.validate()) {
                      final vineyardWine = VineyardWineModel(
                        id: widget.vineyardWineModel?.id,
                        vineyardId: vineyardId,
                        wineModel: selectedWineVariety!,
                        title: _titleController.text.trim(),
                        quantity: int.parse(_quantityController.text.trim()),
                        year: _yearController.text != "" ? int.parse(_yearController.text.trim()) : null,
                        note: _noteController.text != "" ? _noteController.text.trim() : null,
                      );
                      widget.vineyardWineModel != null
                          ? BlocProvider.of<VineyardWineBloc>(context).add(UpdateVineyardWineEvent(vineyardId, vineyardWine))
                          : BlocProvider.of<VineyardWineBloc>(context).add(CreateVineyardWineEvent(vineyardId, vineyardWine));
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
        BlocConsumer<WineVarietyBloc, WineVarietyState>(
          builder: (context, state) {
            if (state is WineVarietyLoadingState) {
              return const AppLoadingIndicator();
            } else {
              return DropdownSearch<WineVarietyModel>(
                popupProps: const PopupProps.menu(showSelectedItems: false, showSearchBox: true),
                items: wineVareityList,
                itemAsString: (WineVarietyModel wc) => wc.title,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.all(10),
                    labelText: AppLocalizations.of(context)!.wineVariety,
                    hintText: AppLocalizations.of(context)!.selectInSelectBox,
                  ),
                ),
                onChanged: (WineVarietyModel? wineVariety) {
                  setState(() {
                    selectedWineVariety = wineVariety;
                  });
                },
                selectedItem: selectedWineVariety,
                clearButtonProps: const ClearButtonProps(isVisible: true),
                validator: (WineVarietyModel? wineVariety) {
                  if (wineVariety == null) return AppLocalizations.of(context)!.inputEmpty;
                  return null;
                },
              );
            }
          },
          listener: (context, state) {
            if (state is WineVarietyListSuccessState) {
              setState(() {
                wineVareityList = state.wineVarietyList;
              });
            } else if (state is WineVarietyFailureState) {
              AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
            }
          },
        ),
        AppTextField(
          controller: _titleController,
          label: AppLocalizations.of(context)!.title,
          inputType: InputType.title,
        ),
        AppTextField(
          controller: _quantityController,
          label: AppLocalizations.of(context)!.vineyardWineQuantity,
          inputType: InputType.integer,
          isRequired: true,
        ),
        AppTextField(
          controller: _yearController,
          label: AppLocalizations.of(context)!.year,
          inputType: InputType.integer,
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
