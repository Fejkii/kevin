import 'package:flutter/widgets.dart';

import 'package:kevin/ui/widgets/app_scaffold.dart';

class AppFilterView extends StatefulWidget {
  final Widget body;
  const AppFilterView({
    super.key,
    required this.body,
  });

  @override
  State<AppFilterView> createState() => _AppFilterViewState();
}

class _AppFilterViewState extends State<AppFilterView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(body: widget.body);
  }
}
