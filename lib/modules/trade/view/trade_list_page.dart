import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/trade/bloc/trade_bloc.dart';
import 'package:kevin/modules/trade/data/model/trade_model.dart';
import 'package:kevin/modules/trade/view/trade_detail_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/services/app_functions.dart';

import '../../../ui/theme/app_colors.dart';
import '../../../ui/widgets/app_list_view.dart';
import '../../../ui/widgets/app_loading_indicator.dart';
import '../../../ui/widgets/app_scaffold.dart';
import '../../../ui/widgets/app_toast_messages.dart';

class TradeListPage extends StatefulWidget {
  const TradeListPage({super.key});

  @override
  State<TradeListPage> createState() => _TradeListPageState();
}

class _TradeListPageState extends State<TradeListPage> {
  late List<TradeModel> purchaseList;
  late TradeType tradeSelect = TradeType.all;

  @override
  void initState() {
    purchaseList = [];
    super.initState();
  }

  void _getTrades() {
    BlocProvider.of<TradeBloc>(context).add(GetTradeListEvent(tradeSelect));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _body(),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.trade),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TradeDetailPage(),
            ),
          );
        },
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _segmentButton(),
        const SizedBox(height: 10),
        _list(),
      ],
    );
  }

  BlocProvider<TradeBloc> _list() {
    return BlocProvider(
      create: (context) => TradeBloc()..add(GetTradeListEvent(tradeSelect)),
      child: BlocConsumer<TradeBloc, TradeState>(
        listener: (context, state) {
          if (state is TradeListSuccessState) {
            purchaseList = state.purchaseList;
          } else if (state is TradeFailureState) {
            AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
          }
        },
        builder: (context, state) {
          if (state is TradeLoadingState) {
            return const AppLoadingIndicator();
          } else {
            return AppListView(listData: purchaseList, itemBuilder: _itemBuilder);
          }
        },
      ),
    );
  }

  Widget _segmentButton() {
    return BlocConsumer<TradeBloc, TradeState>(
      listener: (context, state) {
        if (state is TradeListSuccessState) {
          setState(() {
            purchaseList = state.purchaseList;
          });
        } else if (state is TradeFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
        }
      },
      builder: (context, state) {
        if (state is TradeLoadingState) {
          return const AppLoadingIndicator();
        } else {
          return SegmentedButton(
            segments: <ButtonSegment<TradeType>>[
              ButtonSegment<TradeType>(
                value: TradeType.all,
                label: Text(AppLocalizations.of(context)!.all),
                icon: const Icon(Icons.all_inclusive),
              ),
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
            emptySelectionAllowed: true,
            selected: <TradeType>{tradeSelect},
            onSelectionChanged: (Set<TradeType> newSelection) {
              setState(() {
                tradeSelect = newSelection.first;
              });
              _getTrades();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return AppColors.white;
                  }
                  return AppColors.grey;
                },
              ),
            ),
          );
        }
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    String title = "";
    double totalPrice = 0;
    for (var element in purchaseList[index].tradeItems) {
      title += "${element.title} ";
      totalPrice += element.price;
    }
    return AppListViewItem(
      itemColor: purchaseList[index].tradeTypeId == 1 ? Colors.deepPurple[200] : Colors.teal[200],
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(appFormatDateTime(purchaseList[index].date, dateOnly: true)),
          Text(title),
          Text(appFormatPriceWithUnit(totalPrice)),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TradeDetailPage(tradeModel: purchaseList[index])),
        ).then((value) => _getTrades());
      },
    );
  }
}
