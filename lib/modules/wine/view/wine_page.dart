import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/wine/bloc/wine_bloc.dart';

import 'package:kevin/modules/wine/data/model/wine_model.dart';
import 'package:kevin/modules/wine/view/wine_detail_page.dart';
import 'package:kevin/modules/wine/view/wine_record_detail_page.dart';
import 'package:kevin/modules/wine/view/wine_record_list.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/buttons/app_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantity_input/quantity_input.dart';

import '../../../const/app_values.dart';
import '../../../services/app_functions.dart';
import '../../../ui/widgets/buttons/app_icon_button.dart';

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
  late WineModel wineModel;
  late int wineQuantity;

  @override
  void initState() {
    wineModel = widget.wineModel;
    wineQuantity = wineModel.quantity.toInt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _body(),
      appBar: _appBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(wineModel.title),
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
            );
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
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.wineQuantity),
            QuantityInput(
              value: wineQuantity,
              acceptsZero: true,
              type: QuantityInputType.int,
              step: 10,
              onChanged: (value) => setState(() => wineQuantity = int.parse(value.replaceAll(',', ''))),
              inputWidth: 120,
              buttonColor: Theme.of(context).primaryColor,
              minValue: 0,
              elevation: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            AppIconButton(
              iconButtonType: IconButtonType.save,
              onPress: () {
                wineModel.quantity = wineQuantity.toDouble();
                BlocProvider.of<WineBloc>(context).add(UpdateWineEvent(wineModel: wineModel));
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        _otherInfo(),
        const Divider(height: 30),
        AppButton(
          title: AppLocalizations.of(context)!.addRecord,
          buttonType: ButtonType.add,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WineRecordDetailPage(wineModel: wineModel),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        WineRecordList(wineModel: wineModel),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _otherInfo() {
    return Table(
      children: [
        TableRow(children: [
          TableCell(child: Text(AppLocalizations.of(context)!.acid)),
          TableCell(child: Text(wineModel.acid != null ? parseDouble(wineModel.acid).toString() : AppLocalizations.of(context)!.undefinied)),
        ]),
        TableRow(children: [
          TableCell(child: Text(AppLocalizations.of(context)!.sugar)),
          TableCell(child: Text(wineModel.sugar != null ? parseDouble(wineModel.sugar).toString() : AppLocalizations.of(context)!.undefinied)),
        ]),
        TableRow(children: [
          TableCell(child: Text(AppLocalizations.of(context)!.alcohol)),
          TableCell(child: Text(wineModel.alcohol != null ? parseDouble(wineModel.alcohol).toString() : AppLocalizations.of(context)!.undefinied)),
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
    );
  }
}
