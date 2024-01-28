import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/modules/vineyard/bloc/vineyard_wine_bloc.dart';
import 'package:kevin/modules/vineyard/model/vineyard_wine_summary_model.dart';
import 'package:kevin/modules/vineyard/view/vineyard_detail_page.dart';
import 'package:kevin/modules/vineyard/view/vineyard_record_detail_page.dart';
import 'package:kevin/modules/vineyard/view/vineyard_wine_list_page.dart';
import 'package:kevin/services/app_functions.dart';
import 'package:kevin/ui/widgets/app_box_content.dart';

import '../../../const/app_units.dart';
import '../../../ui/theme/app_colors.dart';
import '../../../ui/widgets/app_list_view.dart';
import '../../../ui/widgets/app_loading_indicator.dart';
import '../../../ui/widgets/app_scaffold.dart';
import '../../../ui/widgets/app_toast_messages.dart';
import '../../../ui/widgets/buttons/app_button.dart';
import '../../../ui/widgets/buttons/app_icon_button.dart';
import '../../../ui/widgets/texts/app_text_with_value.dart';
import '../bloc/vineyard_bloc.dart';
import '../bloc/vineyard_record_bloc.dart';
import '../model/vineyard_model.dart';
import '../model/vineyard_record_model.dart';

class VineyardPage extends StatefulWidget {
  final VineyardModel vineyardModel;
  const VineyardPage({
    Key? key,
    required this.vineyardModel,
  }) : super(key: key);

  @override
  State<VineyardPage> createState() => _VineyardPageState();
}

class _VineyardPageState extends State<VineyardPage> {
  late VineyardModel vineyardModel;
  late List<VineyardRecordModel> vineyardRecordList;
  late VineyardWineSummaryModel? vineyardWineSummaryModel;

  @override
  void initState() {
    vineyardModel = widget.vineyardModel;
    vineyardRecordList = [];
    _getVineyardRecordList();
    _getVineyardWineSummary();
    vineyardWineSummaryModel = null;
    super.initState();
  }

  void _getVineyard() async {
    BlocProvider.of<VineyardBloc>(context).add(GetVineyardEvent(vineyardModel.id!));
  }

  void _getVineyardRecordList() async {
    BlocProvider.of<VineyardRecordBloc>(context).add(VineyardRecordListEvent(vineyardId: vineyardModel.id!));
  }

  void _getVineyardWineSummary() async {
    BlocProvider.of<VineyardWineBloc>(context).add(VineyardWineSummaryEvent(vineyardId: vineyardModel.id!));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _bodyWidget(),
      appBar: AppBar(
        title: Text(vineyardModel.title),
        actions: [
          AppIconButton(
            iconButtonType: IconButtonType.edit,
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VineyardDetailPage(vineyardModel: vineyardModel),
                ),
              ).then((value) => _getVineyard());
              // );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VineyardRecordDetailPage(vineyardModel: vineyardModel),
            ),
          ).then((value) => _getVineyardRecordList());
        },
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _otherInfo(),
        const SizedBox(height: 20),
        _vineyardRecordList(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _otherInfo() {
    return BlocConsumer<VineyardWineBloc, VineyardWineState>(
      listener: (context, state) {
        if (state is VineyardWineSummarySuccessState) {
          vineyardWineSummaryModel = state.vineyardWineSummaryModel;
        } else if (state is VineyardWineFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
        }
      },
      builder: (context, state) {
        if (state is VineyardWineLoadingState) {
          return const AppLoadingIndicator();
        } else {
          return AppBoxContent(
            child: Column(
              children: [
                AppTextWithValue(
                  text: AppLocalizations.of(context)!.area,
                  value: appFormatDoubleToString(vineyardModel.area),
                  unit: AppUnits.squareMeter,
                ),
                AppTextWithValue(
                  text: AppLocalizations.of(context)!.wineVarietyCount,
                  value: vineyardWineSummaryModel?.count,
                ),
                AppTextWithValue(
                  text: AppLocalizations.of(context)!.vineyardWineQuantity,
                  value: vineyardWineSummaryModel?.quantitySum,
                ),
                const SizedBox(height: 20),
                AppButton(
                  title: AppLocalizations.of(context)!.vineyardWines,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VineyardWineListPage(vineyardId: vineyardModel.id!),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void _getData() {
    BlocProvider.of<VineyardRecordBloc>(context).add(VineyardRecordListEvent(vineyardId: widget.vineyardModel.id!));
  }

  Widget _vineyardRecordList() {
    return BlocConsumer<VineyardRecordBloc, VineyardRecordState>(
      listener: (context, state) {
        if (state is VineyardRecordListSuccessState) {
          vineyardRecordList = state.vineyardRecordList;
        } else if (state is VineyardRecordFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
        }
      },
      builder: (context, state) {
        if (state is VineyardRecordLoadingState) {
          return const AppLoadingIndicator();
        } else {
          return AppListView(
            title: AppLocalizations.of(context)!.vineyardRecord,
            listData: vineyardRecordList,
            itemBuilder: _itemBuilder,
          );
        }
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    VineyardRecordType vineyardRecordType =
        VineyardRecordType.values.firstWhere((wrt) => wrt.getId() == vineyardRecordList[index].vineyardRecordTypeId);
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(appFormatDateTime(vineyardRecordList[index].date, dateOnly: true)),
          Text(vineyardRecordList[index].title ?? vineyardRecordType.getTranslate(context)),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VineyardRecordDetailPage(
              vineyardModel: widget.vineyardModel,
              vineyardRecordModel: vineyardRecordList[index],
            ),
          ),
        ).then((value) => _getData());
      },
    );
  }
}
