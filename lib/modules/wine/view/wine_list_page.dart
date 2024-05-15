import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/const/app_constant.dart';
import 'package:kevin/modules/wine/data/model/wine_list_filter_model.dart';
import 'package:kevin/modules/wine/data/model/wine_model.dart';
import 'package:kevin/modules/wine/view/wine_detail_page.dart';
import 'package:kevin/modules/wine/view/wine_filter_view.dart';
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
import 'package:kevin/ui/widgets/widget_model/filter_model.dart';

import '../bloc/wine_bloc.dart';
import '../data/model/wine_classification_model.dart';
import '../data/model/wine_variety_model.dart';

class WineListPage extends StatefulWidget {
  const WineListPage({super.key});

  @override
  State<WineListPage> createState() => _WineListPageState();
}

class _WineListPageState extends State<WineListPage> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  final TextEditingController _searchController = TextEditingController();
  late List<WineModel> wineList = [];
  late List<WineModel> wineFilteredList = [];
  late List<WineClassificationModel> wineClassificationList;
  late List<WineVarietyModel> wineVarietyList;
  late WineListFilterModel wineListFilterModel;

  @override
  void initState() {
    wineClassificationList = appPreferences.getWineClassificationList();
    wineVarietyList = appPreferences.getWineVarietyList();
    wineListFilterModel = appPreferences.getWineListFilter();
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

  void _getWineList() {
    BlocProvider.of<WineBloc>(context).add(GetWineListEvent());
    setState(() {
      wineFilteredList = wineList;
    });
    _filterWines();
  }

  void _searchWine() {
    // TODO: Fixnout vyhledávání s filtrováním. Když mám něco vyfiltrováno, pak dám vyheldat, list se resetne.
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

  void _filterWines() {
    List<WineModel> wineListFromFilter = [];

    // WineVariety Filter
    // for (var filteredVariety in wineListFilterModel.wineVarieties) {
    //   wineListFromFilter = wineList.where((wine) {
    //     bool containVariety = false;
    //     for (var variety in wine.wineVarieties) {
    //       variety.title == filteredVariety.title ? containVariety = true : false;
    //     }
    //     return containVariety;
    //   }).toList();
    // }

    // // WineClassification Filter
    // for (var filtereClassification in wineListFilterModel.wineClassifications) {
    //   if (wineListFilterModel.wineVarieties.isNotEmpty) {
    //     wineListFromFilter = wineListFromFilter.where((wine) {
    //       return wine.wineClassification != null ? wine.wineClassification!.title == filtereClassification.title : false;
    //     }).toList();
    //   } else {
    //     wineListFromFilter = wineList.where((wine) {
    //       return wine.wineClassification != null ? wine.wineClassification!.title == filtereClassification.title : false;
    //     }).toList();
    //   }
    // }

    wineListFromFilter = wineList.where((wine) {
      return (wineListFilterModel.wineClassifications.isNotEmpty || wineListFilterModel.wineClassifications.contains(wine.wineClassification));
    }).toList();

    wineListFilterModel.activeFilters != 0 ? wineFilteredList = wineListFromFilter : wineFilteredList = wineList;
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppSearchBar(
      title: AppLocalizations.of(context)!.wine,
      enableSearch: true,
      searchController: _searchController,
      filterModel: _filterModal(),
    );
  }

  FilterModel _filterModal() {
    return FilterModel(
      isFilterActive: true,
      title: AppLocalizations.of(context)!.wineFilter,
      filterBody: WineFilterView(
        wineVarietyList: wineVarietyList,
        wineClassificationList: wineClassificationList,
        notifyWineFilterChanged: _refreshActiveFilterNumber,
      ),
      activeFilters: wineListFilterModel.activeFilters,
    );
  }

  void _refreshActiveFilterNumber(WineListFilterModel wineListFilter) {
    setState(() {
      wineListFilterModel = wineListFilter;
    });
    _filterWines();
  }

  Widget _addWineButton(BuildContext context) {
    return AppFloatingButton(onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WineDetailPage(
            wineClassificationList: wineClassificationList,
            wineVarietyList: wineVarietyList,
          ),
        ),
      ).then((value) => _getWineList());
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
              _filterWines();
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wineFilteredList[index].title!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(wineFilteredList[index].year.toString()),
            ],
          ),
          Text(appFormatLiter(wineFilteredList[index].quantity, context)),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WinePage(
              wineClassificationList: wineClassificationList,
              wineVarietyList: wineVarietyList,
              wineModel: wineFilteredList[index],
            ),
          ),
        ).then((value) => _getWineList());
      },
    );
  }
}
