import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/modules/trade/bloc/trade_bloc.dart';
import 'package:kevin/modules/trade/data/model/trade_model.dart';
import 'package:kevin/modules/trade/view/trade_item_form.dart';
import 'package:kevin/ui/widgets/app_form.dart';
import 'package:kevin/ui/widgets/buttons/app_segmented_button.dart';

import '../../../services/app_functions.dart';
import '../../../ui/widgets/app_date_picker.dart';
import '../../../ui/widgets/app_loading_indicator.dart';
import '../../../ui/widgets/app_scaffold.dart';
import '../../../ui/widgets/app_toast_messages.dart';
import '../../../ui/widgets/buttons/app_button.dart';
import '../../../ui/widgets/buttons/app_icon_button.dart';
import '../../../ui/widgets/texts/app_text_field.dart';
import '../data/model/trade_item_model.dart';

class TradeDetailPage extends StatefulWidget {
  final TradeModel? tradeModel;

  const TradeDetailPage({
    super.key,
    this.tradeModel,
  });
  @override
  State<StatefulWidget> createState() {
    return _TradeDetailPageState();
  }
}

class _TradeDetailPageState extends State<TradeDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<TradeItemForm> tradeItemForms = List.empty(growable: true);

  late TradeType tradeType = TradeType.sale;
  late TradeModel? tradeModel;
  late TradeItemModel newTradeItemModel = TradeItemModel(tradeItemForms.length, "", 0, 0, 0);

  @override
  void initState() {
    super.initState();

    tradeModel = null;

    if (widget.tradeModel != null) {
      tradeModel = widget.tradeModel;
      _titleController.text = tradeModel!.title;
      _dateController.text = tradeModel!.date.toIso8601String();
      _noteController.text = tradeModel!.note ?? "";
      tradeType = TradeType.values.firstWhere((element) => element.getId() == tradeModel!.tradeTypeId);
      for (TradeItemModel tradeItemModel in tradeModel!.tradeItems) {
        onAddItem(tradeItemModel);
      }
    } else {
      onAddItem(null);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  //Delete specific form
  onRemoveItem(TradeItemModel tradeItem) {
    setState(() {
      int index = tradeItemForms.indexWhere((element) => element.tradeItemModel.id == tradeItem.id);

      if (tradeItemForms.isNotEmpty) tradeItemForms.removeAt(index);
    });
  }

  onAddItem(TradeItemModel? tradeItemModel) {
    setState(() {
      tradeItemForms.add(
        TradeItemForm(
          index: tradeItemForms.length,
          tradeItemModel: tradeItemModel ?? newTradeItemModel,
          onRemove: () => onRemoveItem(newTradeItemModel),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: _appBar(context),
      body: _body(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(tradeType == TradeType.sale ? AppLocalizations.of(context)!.sale : AppLocalizations.of(context)!.purchase),
      actions: [
        BlocConsumer<TradeBloc, TradeState>(
          listener: (context, state) {
            if (state is TradeSuccessState) {
              tradeModel != null
                  ? AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updatedSuccessfully, ToastState.success)
                  : AppToastMessage().showToastMsg(AppLocalizations.of(context)!.createdSuccessfully, ToastState.success);
              Navigator.pop(context);
            } else if (state is TradeFailureState) {
              AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
            }
          },
          builder: (context, state) {
            if (state is TradeLoadingState) {
              return const AppLoadingIndicator();
            } else {
              return AppIconButton(
                iconButtonType: IconButtonType.save,
                onPress: (() {
                  onSave();
                }),
              );
            }
          },
        ),
      ],
    );
  }

  void onSave() {
    bool isTradeItemsValid = true;

    for (TradeItemForm tradeItemForm in tradeItemForms) {
      isTradeItemsValid = (isTradeItemsValid && tradeItemForm.isValidated());
    }

    if (_formKey.currentState!.validate() && isTradeItemsValid) {
      List<TradeItemModel> tradeItems = tradeItemForms.map((e) => e.getTradeItemModel()).toList();
      if (tradeModel != null) {
        tradeModel!.title = _titleController.text.trim();
        tradeModel!.date = appToDateTime(_dateController.text.trim());
        tradeModel!.note = _noteController.text.trim();
        tradeModel!.updated = DateTime.now();
        tradeModel!.tradeTypeId = tradeType.getId();
        tradeModel!.tradeItems = tradeItems;

        BlocProvider.of<TradeBloc>(context).add(
          UpdateTradeEvent(tradeModel: tradeModel!),
        );
      } else {
        BlocProvider.of<TradeBloc>(context).add(
          CreateTradeEvent(
            tradeModel: TradeModel(
              title: _titleController.text.trim(),
              date: appToDateTime(_dateController.text.trim()),
              tradeTypeId: tradeType.getId(),
              tradeItems: tradeItems,
              note: _noteController.text.trim(),
              created: DateTime.now(),
            ),
          ),
        );
      }
    }
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        _form(context),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _form(BuildContext context) {
    return AppForm(
      formKey: _formKey,
      content: <Widget>[
        AppSegmentedButton(
          segments: <ButtonSegment<TradeType>>[
            ButtonSegment<TradeType>(
              value: TradeType.sale,
              label: Text(AppLocalizations.of(context)!.sale),
              icon: const Icon(Icons.calendar_view_day),
            ),
            ButtonSegment<TradeType>(
              value: TradeType.purchase,
              label: Text(AppLocalizations.of(context)!.purchase),
              icon: const Icon(Icons.calendar_view_week),
            ),
          ],
          selected: <TradeType>{tradeType},
          onSelectionChanged: (newSelection) {
            setState(() {
              tradeType = newSelection.first;
            });
          },
        ),
        AppDatePicker(
          controller: _dateController,
          label: AppLocalizations.of(context)!.date,
          initDate: tradeModel?.date,
          fillTodayDate: true,
          setIcon: true,
        ),
        ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tradeItemForms.length,
          itemBuilder: (_, index) {
            return tradeItemForms[index];
          },
        ),
        AppButton(
          title: AppLocalizations.of(context)!.addNextItem,
          onTap: () {
            onAddItem(null);
          },
          buttonType: ButtonType.add,
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
