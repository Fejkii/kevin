import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kevin/ui/widgets/texts/app_title_text.dart';

class AppListView extends StatelessWidget {
  final String? title;
  final List listData;
  final IndexedWidgetBuilder itemBuilder;
  const AppListView({
    Key? key,
    this.title,
    required this.listData,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null)
          Text(
            title!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (title != null) const SizedBox(height: 4),
        listData.isNotEmpty
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
                    const SizedBox(height: 15),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.search_off, size: 30),
                    ),
                    AppTitleText(text: AppLocalizations.of(context)!.emptyData),
                  ],
                ),
              )
      ],
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: itemBody,
            ),
          ),
        ),
      ),
    );
  }
}
