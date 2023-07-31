import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/wine/bloc/wine_bloc.dart';
import 'package:kevin/modules/wine/data/model/wine_model.dart';
import 'package:kevin/modules/wine/view/wine_detail_page.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/app_list_view.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';

class WineListPage extends StatefulWidget {
  const WineListPage({super.key});

  @override
  State<WineListPage> createState() => _WineListPageState();
}

class _WineListPageState extends State<WineListPage> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  late List<WineModel> wineList;

  @override
  void initState() {
    wineList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _body(),
      appBar: _appBar(context),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.wine),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const WineDetailPage()));
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _body() {
    return BlocProvider(
      create: (context) => WineBloc()..add(WineListRequestEvent()),
      child: BlocConsumer<WineBloc, WineState>(
        listener: (context, state) {
          if (state is WineListSuccessState) {
            wineList = state.wineList;
          } else if (state is WineFailureState) {
            AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
          }
        },
        builder: (context, state) {
          if (state is WineLoadingState) {
            return const AppLoadingIndicator();
          } else {
            return AppListView(listData: wineList, itemBuilder: _itemBuilder);
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
          Text(wineList[index].title),
          Text(wineList[index].quantity.toString()),
        ],
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => WineDetailPage(wineModel: wineList[index])));
      },
    );
  }
}
