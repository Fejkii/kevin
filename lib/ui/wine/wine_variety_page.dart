import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/bloc/wine_variety/wine_variety_bloc.dart';
import 'package:kevin/models/wine_variety_model.dart';
import 'package:kevin/repository/wine_variety_repository.dart';
import 'package:kevin/ui/widgets/app_list_view.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';
import 'package:kevin/ui/wine/wine_variety_defail_page.dart';

class WineVarietyListView extends StatefulWidget {
  const WineVarietyListView({super.key});

  @override
  State<WineVarietyListView> createState() => _WineVarietyListViewState();
}

class _WineVarietyListViewState extends State<WineVarietyListView> {
  late List<WineVarietyModel> wineVarietyList;

  @override
  void initState() {
    wineVarietyList = [];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _wineVarietyList(),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.wineVarieties),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WineVarietyDetailPage()));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _wineVarietyList() {
    return BlocProvider(
      create: (context) => WineVarietyBloc(WineVarietyRepository())..add(WineVarietyListRequestEvent()),
      child: BlocConsumer<WineVarietyBloc, WineVarietyState>(
        listener: (context, state) {
          if (state is WineVarietyListSuccessState) {
            wineVarietyList = state.wineVarietyList;
          } else if (state is WineVarietyFailureState) {
            AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
          }
        },
        builder: (context, state) {
          if (state is WineVarietyLoadingState) {
            return const AppLoadingIndicator();
          } else {
            return AppListView(listData: wineVarietyList, itemBuilder: _itemBuilder);
          }
        },
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(wineVarietyList[index].title),
          Text(wineVarietyList[index].code),
        ],
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => WineVarietyDetailPage(wineVariety: wineVarietyList[index])));
      },
    );
  }
}
