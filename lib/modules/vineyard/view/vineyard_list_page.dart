import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/modules/vineyard/bloc/vineyard_bloc.dart';
import 'package:kevin/modules/vineyard/view/vineyard_detail_page.dart';
import 'package:kevin/modules/vineyard/view/vineyard_page.dart';

import '../../../ui/widgets/app_list_view.dart';
import '../../../ui/widgets/app_loading_indicator.dart';
import '../../../ui/widgets/app_scaffold.dart';
import '../../../ui/widgets/app_toast_messages.dart';
import '../model/vineyard_model.dart';

class VineyardListPage extends StatefulWidget {
  const VineyardListPage({Key? key}) : super(key: key);

  @override
  State<VineyardListPage> createState() => _VineyardListPageState();
}

class _VineyardListPageState extends State<VineyardListPage> {
  late List<VineyardModel> vineyardList = [];

  @override
  void initState() {
    _getData();
    super.initState();
  }


  void _getData() {
    BlocProvider.of<VineyardBloc>(context).add(VineyardListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _list(),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.vineyards),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VineyardDetailPage(),
                ),
              ).then((value) => _getData());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _list() {
    return BlocConsumer<VineyardBloc, VineyardState>(
      listener: (context, state) {
        if (state is VineyardListSuccessState) {
          vineyardList = state.vineyardList;
        } else if (state is VineyardFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
        }
      },
      builder: (context, state) {
        if (state is VineyardLoadingState) {
          return const AppLoadingIndicator();
        } else {
          return AppListView(listData: vineyardList, itemBuilder: _itemBuilder);
        }
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(vineyardList[index].title),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VineyardPage(vineyardModel: vineyardList[index]),
          ),
        ).then((value) => _getData());
      },
    );
  }
}
