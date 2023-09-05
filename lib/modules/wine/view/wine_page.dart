import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/const/app_units.dart';
import 'package:kevin/modules/wine/bloc/wine_bloc.dart';

import 'package:kevin/modules/wine/data/model/wine_model.dart';
import 'package:kevin/modules/wine/view/wine_detail_page.dart';
import 'package:kevin/modules/wine/view/wine_record_detail_page.dart';
import 'package:kevin/ui/widgets/app_box_content.dart';
import 'package:kevin/ui/widgets/app_quantity_input.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../const/app_values.dart';
import '../../../services/app_functions.dart';
import '../../../ui/theme/app_colors.dart';
import '../../../ui/widgets/app_list_view.dart';
import '../../../ui/widgets/app_loading_indicator.dart';
import '../../../ui/widgets/app_toast_messages.dart';
import '../../../ui/widgets/buttons/app_icon_button.dart';
import '../bloc/wine_record_bloc.dart';
import '../data/model/wine_record_model.dart';

class WinePage extends StatefulWidget {
  final WineModel wineModel;
  const WinePage({
    Key? key,
    required this.wineModel,
  }) : super(key: key);

  @override
  State<WinePage> createState() => _WinePageState();
}

class _WinePageState extends State<WinePage> {
  final TextEditingController quantityController = TextEditingController();
  late WineModel wineModel;
  late int wineQuantity;
  late List<WineRecordModel> wineRecordList;

  @override
  void initState() {
    _getWineRecords();
    wineModel = widget.wineModel;
    wineQuantity = wineModel.quantity.toInt();
    wineRecordList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _body(),
      appBar: _appBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WineRecordDetailPage(wineModel: wineModel),
            ),
          ).then((value) => _getWineRecords());
        },
      ),
    );
  }

  void _getWine() {
    BlocProvider.of<WineBloc>(context).add(GetWineEvent(widget.wineModel.id));
  }

  void _getWineRecords() {
    BlocProvider.of<WineRecordBloc>(context).add(WineRecordListEvent(widget.wineModel.id));
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(wineModel.title!),
      actions: [
        AppIconButton(
          iconButtonType: IconButtonType.edit,
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WineDetailPage(
                  wineModel: wineModel,
                ),
              ),
            ).then((value) => _getWine());
          },
        ),
      ],
    );
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _addQuantity(),
        _otherInfo(),
        const Divider(height: 30),
        _wineRecordList(),
        const SizedBox(height: 20),
      ],
    );
  }

  BlocConsumer<WineBloc, WineState> _addQuantity() {
    return BlocConsumer<WineBloc, WineState>(
      listener: (context, state) {
        if (state is WineSuccessState) {
          AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updatedSuccessfully, ToastState.success);
        } else if (state is WineFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
        }
      },
      builder: (context, state) {
        if (state is WineLoadingState) {
          return const AppLoadingIndicator();
        } else {
          return AppBoxContent(
            title: AppLocalizations.of(context)!.wineQuantity,
            child: AppQuantityInput(
              inputController: quantityController,
              initValue: wineQuantity,
              step: 10,
              unit: AppUnits().liter(quantityController.text, context),
              onChange: (value) {
                setState(() {
                  wineQuantity = value;
                });
              },
              onSave: () {
                wineModel.quantity = wineQuantity.toDouble();
                BlocProvider.of<WineBloc>(context).add(UpdateWineEvent(wineModel: wineModel));
              },
            ),
          );
        }
      },
    );
  }

  Widget _otherInfo() {
    return AppBoxContent(
      title: AppLocalizations.of(context)!.wineInfo,
      child: Table(
        children: [
          TableRow(children: [
            TableCell(child: Text(AppLocalizations.of(context)!.acid)),
            TableCell(child: Text(wineModel.acid != null ? appFormatGramPerLiter(wineModel.acid) : AppLocalizations.of(context)!.undefinied)),
          ]),
          TableRow(children: [
            TableCell(child: Text(AppLocalizations.of(context)!.sugar)),
            TableCell(child: Text(wineModel.sugar != null ? appFormatGramPerLiter(wineModel.sugar) : AppLocalizations.of(context)!.undefinied)),
          ]),
          TableRow(children: [
            TableCell(child: Text(AppLocalizations.of(context)!.alcohol)),
            TableCell(child: Text(wineModel.alcohol != null ? appFormatPercent(wineModel.alcohol) : AppLocalizations.of(context)!.undefinied)),
          ]),
          TableRow(children: [
            TableCell(child: Text(AppLocalizations.of(context)!.created)),
            TableCell(child: Text(appFormatDateTime(wineModel.created))),
          ]),
          if (wineModel.updated != null)
            TableRow(children: [
              TableCell(child: Text(AppLocalizations.of(context)!.updated)),
              TableCell(child: Text(appFormatDateTime(wineModel.updated!))),
            ]),
          if (wineModel.note != null && wineModel.note != AppConstant.EMPTY)
            TableRow(children: [
              TableCell(child: Text(AppLocalizations.of(context)!.note)),
              TableCell(child: Text(wineModel.note!)),
            ]),
        ],
      ),
    );
  }

  Widget _wineRecordList() {
    return BlocConsumer<WineRecordBloc, WineRecordState>(
      listener: (context, state) {
        if (state is WineRecordListSuccessState) {
          wineRecordList = state.wineRecordList;
        } else if (state is WineRecordFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
        }
      },
      builder: (context, state) {
        if (state is WineRecordLoadingState) {
          return const AppLoadingIndicator();
        } else {
          return AppListView(
            title: AppLocalizations.of(context)!.wineRecord,
            listData: wineRecordList,
            itemBuilder: _itemBuilder,
          );
        }
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    WineRecordType wineRecordType = WineRecordType.values.firstWhere((wrt) => wrt.getId() == wineRecordList[index].wineRecordTypeId);
    dynamic value = "";
    String title = wineRecordType.getTranslate(context);
    if (wineRecordType == WineRecordType.measurementFreeSulfure) {
      value = WineRecordFreeSulfure.fromJson(wineRecordList[index].data).freeSulfure.toStringAsFixed(0);
    }
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(appFormatDateTime(wineRecordList[index].date, dateOnly: true)),
          Text(title),
          Text(value),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WineRecordDetailPage(
              wineModel: widget.wineModel,
              wineRecord: wineRecordList[index],
            ),
          ),
        ).then((value) => _getWineRecords());
      },
      itemColor: wineRecordList[index].isInProgress == true ? AppColors.green : null,
    );
  }
}
