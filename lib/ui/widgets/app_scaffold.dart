import 'package:flutter/material.dart';
import 'package:kevin/ui/app_sidebar.dart';

class AppScaffold extends StatefulWidget {
  final Widget body;
  final AppBar? appBar;
  final bool? hasSidebar;
  const AppScaffold({
    Key? key,
    required this.body,
    this.appBar,
    this.hasSidebar,
  }) : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        drawer: widget.hasSidebar != null && widget.hasSidebar == true ? AppSidebar() : null,
        appBar: widget.appBar,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: widget.body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
