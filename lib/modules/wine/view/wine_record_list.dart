import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/wine/bloc/wine_record_bloc.dart';
import 'package:kevin/modules/wine/data/model/wine_model.dart';
import 'package:kevin/modules/wine/view/wine_record_detail_page.dart';

import '../../../services/app_functions.dart';
import '../../../ui/theme/app_colors.dart';
import '../../../ui/widgets/app_list_view.dart';
import '../../../ui/widgets/app_loading_indicator.dart';
import '../../../ui/widgets/app_toast_messages.dart';
import '../data/model/wine_record_model.dart';

class WineRecordList extends StatefulWidget {
  final WineModel wineModel;
  const WineRecordList({
    Key? key,
    required this.wineModel,
  }) : super(key: key);

  @override
  State<WineRecordList> createState() => _WineRecordListState();
}

class _WineRecordListState extends State<WineRecordList> {
  late List<WineRecordModel> wineRecordList;

  @override
  void initState() {
    wineRecordList = [];
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getData() {
    BlocProvider.of<WineRecordBloc>(context).add(WineRecordListEvent(widget.wineModel.id));
  }

  @override
  Widget build(BuildContext context) {
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
          return AppListView(listData: wineRecordList, itemBuilder: _itemBuilder);
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
        ).then((value) => _getData());
      },
      itemColor: wineRecordList[index].isInProgress == true ? AppColors.green : null,
    );
  }
}
