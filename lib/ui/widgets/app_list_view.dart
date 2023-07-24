import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kevin/ui/widgets/texts/app_title_text.dart';

class AppListView extends StatelessWidget {
  final List listData;
  final IndexedWidgetBuilder itemBuilder;
  const AppListView({
    Key? key,
    required this.listData,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return listData.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: listData.length,
            itemBuilder: itemBuilder,
          )
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search_off, size: 30),
                ),
                AppTitleText(text: AppLocalizations.of(context)!.emptyData),
              ],
            ),
          );
  }
}

class AppListViewItem extends StatelessWidget {
  final Widget itemBody;
  final Function()? onTap;
  final Function(BuildContext?)? onDelete;
  final Color? itemColor;
  const AppListViewItem({
    Key? key,
    required this.itemBody,
    this.onTap,
    this.onDelete,
    this.itemColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: onDelete != null,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: onDelete,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: AppLocalizations.of(context)!.delete,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: itemColor,
          child: Center(
            heightFactor: 2.5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: itemBody,
            ),
          ),
        ),
      ),
    );
  }
}
