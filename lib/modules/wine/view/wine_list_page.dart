import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/const/app_constant.dart';
import 'package:kevin/modules/wine/bloc/wine_bloc.dart';
import 'package:kevin/modules/wine/data/model/wine_model.dart';
import 'package:kevin/modules/wine/view/wine_detail_page.dart';
import 'package:kevin/modules/wine/view/wine_page.dart';
import 'package:kevin/services/app_functions.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/app_list_view.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/app_search_bar.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';
import 'package:kevin/ui/widgets/buttons/app_floating_button.dart';

class WineListPage extends StatefulWidget {
  const WineListPage({super.key});

  @override
  State<WineListPage> createState() => _WineListPageState();
}

class _WineListPageState extends State<WineListPage> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  final TextEditingController _searchController = TextEditingController();
  late List<WineModel> wineList;
  late List<WineModel> wineFilteredList;

  @override
  void initState() {
    wineList = [];
    wineFilteredList = [];
    _searchController.addListener(() {
      _searchWine();
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _body(),
      appBar: _appBar(context),
      floatingActionButton: _addWineButton(context),
    );
  }

  void _searchWine() {
    setState(() {
      wineFilteredList = wineList.where((wine) {
        final String input = _searchController.text.toLowerCase();
        String classification = wine.wineClassification?.title ?? AppConstant.EMPTY;
        String variety = AppConstant.EMPTY;
        for (var element in wine.wineVarieties) {
          variety += "${element.title} ${element.code}";
        }
        String searchableWine = "${wine.title} ${wine.note} $classification ${wine.year} $variety".toLowerCase();
        return searchableWine.contains(input);
      }).toList();
    });
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppSearchBar(
      title: AppLocalizations.of(context)!.wine,
      enableSearch: true,
      searchController: _searchController,
    );
  }

  Widget _addWineButton(BuildContext context) {
    return AppFloatingButton(onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WineDetailPage(),
        ),
      ).then((value) => _getWineLit());
    });
  }

  void _getWineLit() {
    BlocProvider.of<WineBloc>(context).add(GetWineListEvent());
    setState(() {
      wineFilteredList = wineList;
    });
  }

  Widget _body() {
    return BlocProvider(
      create: (context) => WineBloc()..add(GetWineListEvent()),
      child: BlocConsumer<WineBloc, WineState>(
        listener: (context, state) {
          if (state is WineListSuccessState) {
            setState(() {
              wineList = state.wineList;
              wineFilteredList = state.wineList;
            });
          } else if (state is WineFailureState) {
            AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
          }
        },
        builder: (context, state) {
          if (state is WineLoadingState) {
            return const AppLoadingIndicator();
          } else {
            return AppListView(listData: wineFilteredList, itemBuilder: _itemBuilder);
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
          Text(wineFilteredList[index].title!),
          Text(appFormatLiter(wineFilteredList[index].quantity, context)),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WinePage(wineModel: wineFilteredList[index]),
          ),
        ).then((value) => _getWineLit());
      },
    );
  }
}
