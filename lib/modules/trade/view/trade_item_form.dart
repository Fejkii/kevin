import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/services/app_functions.dart';
import 'package:kevin/ui/theme/app_colors.dart';
import 'package:kevin/ui/widgets/buttons/app_icon_button.dart';

import '../../../const/app_units.dart';
import '../../../ui/widgets/texts/app_text_field.dart';
import '../data/model/trade_item_model.dart';

class TradeItemForm extends StatefulWidget {
  final int index;
  final TradeItemModel tradeItemModel;
  final Function onRemove;
  final state = _TradeItemFormState();

  TradeItemForm({
    Key? key,
    required this.tradeItemModel,
    required this.onRemove,
    required this.index,
  }) : super(key: key);

  bool isValidated() => state.validate();

  TradeItemModel getTradeItemModel() => state.getDataFromForm();

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => state;
}

class _TradeItemFormState extends State<TradeItemForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();

  static const List<String> units = AppUnits.tradeUnits;
  String selectedUnit = units.first;

  @override
  void initState() {
    _titleController.text = widget.tradeItemModel.title;
    _quantityController.text = appFormatDoubleToString(widget.tradeItemModel.quantity);
    _priceController.text = appFormatDoubleToString(widget.tradeItemModel.price);
    _unitPriceController.text = appFormatDoubleToString(widget.tradeItemModel.unitPrice);

    super.initState();
  }

  void onQuantityChange(String value) {
    if (_quantityController.text != "" && _priceController.text != "" && _quantityController.text != "0" && _priceController.text != "0") {
      setState(() {
        _unitPriceController.text = appFormatPriceToTextField(double.parse(_priceController.text) / double.parse(_quantityController.text));
      });
    }
  }

  void onPriceChange(String value) {
    if (_quantityController.text != "" && _priceController.text != "" && _quantityController.text != "0" && _priceController.text != "0") {
      setState(() {
        _unitPriceController.text = appFormatPriceToTextField(double.parse(_priceController.text) / double.parse(_quantityController.text));
      });
    }
  }

  void onUnitPriceChange(String value) {
    if (_quantityController.text != "" && _unitPriceController.text != "" && _quantityController.text != "0" && _unitPriceController.text != "0") {
      setState(() {
        _priceController.text = appFormatPriceToTextField(double.parse(_unitPriceController.text) * double.parse(_quantityController.text));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _titleController,
                      label: AppLocalizations.of(context)!.title,
                      isRequired: true,
                    ),
                  ),
                  AppIconButton(
                    iconButtonType: IconButtonType.close,
                    onPress: () => widget.onRemove(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _quantityController,
                      label: AppLocalizations.of(context)!.amount,
                      isRequired: true,
                      inputType: InputType.double,
                      keyboardType: TextInputType.number,
                      onChange: onQuantityChange,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButton<String>(
                      hint: Text(AppLocalizations.of(context)!.unit),
                      value: selectedUnit,
                      onChanged: (String? value) {
                        setState(() {
                          selectedUnit = value!;
                        });
                      },
                      items: units.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _priceController,
                      label: AppLocalizations.of(context)!.price,
                      isRequired: true,
                      inputType: InputType.double,
                      keyboardType: TextInputType.number,
                      unit: AppUnits.crown,
                      onChange: onPriceChange,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppTextField(
                      controller: _unitPriceController,
                      label: AppLocalizations.of(context)!.unitPrice,
                      isRequired: true,
                      inputType: InputType.double,
                      keyboardType: TextInputType.number,
                      unit: AppUnits.crown,
                      onChange: onUnitPriceChange,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TradeItemModel getDataFromForm() {
    widget.tradeItemModel.title = _titleController.text;
    widget.tradeItemModel.quantity = appFormatStringToDouble(_quantityController.text)!;
    widget.tradeItemModel.price = appFormatStringToDouble(_priceController.text)!;
    widget.tradeItemModel.unitPrice = appFormatStringToDouble(_unitPriceController.text)!;

    return widget.tradeItemModel;
  }

  bool validate() {
    //Validate Form Fields
    bool validate = _formKey.currentState!.validate();
    if (validate) _formKey.currentState!.save();
    return validate;
  }
}
