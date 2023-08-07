// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/modules/vineyard/bloc/vineyard_wine_bloc.dart';
import 'package:kevin/modules/vineyard/view/vineyard_wine_detail_page.dart';

import '../../../ui/widgets/app_list_view.dart';
import '../../../ui/widgets/app_loading_indicator.dart';
import '../../../ui/widgets/app_scaffold.dart';
import '../../../ui/widgets/app_toast_messages.dart';
import '../model/vineyard_wine_model.dart';

class VineyardWineListPage extends StatefulWidget {
  final String vineyardId;
  const VineyardWineListPage({
    Key? key,
    required this.vineyardId,
  }) : super(key: key);

  @override
  State<VineyardWineListPage> createState() => _VineyardWineListPageState();
}

class _VineyardWineListPageState extends State<VineyardWineListPage> {
  late List<VineyardWineModel> vineyardWineList;

  @override
  void initState() {
    vineyardWineList = [];
    _getData();
    super.initState();
  }

  void _getData() {
    BlocProvider.of<VineyardWineBloc>(context).add(VineyardWineListEvent(vineyardId: widget.vineyardId));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _list(),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.vineyardWines),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VineyardWineDetailPage(vineyardId: widget.vineyardId),
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
    return BlocConsumer<VineyardWineBloc, VineyardWineState>(
      listener: (context, state) {
        if (state is VineyardWineListSuccessState) {
          vineyardWineList = state.vineyardWineList;
        } else if (state is VineyardWineFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
        }
      },
      builder: (context, state) {
        if (state is VineyardWineLoadingState) {
          return const AppLoadingIndicator();
        } else {
          return AppListView(listData: vineyardWineList, itemBuilder: _itemBuilder);
        }
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(vineyardWineList[index].title),
          Text(vineyardWineList[index].quantity.toString()),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VineyardWineDetailPage(
              vineyardId: vineyardWineList[index].vineyardId,
              vineyardWineModel: vineyardWineList[index],
            ),
          ),
        ).then((value) => _getData());
      },
    );
  }
}
