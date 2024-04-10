import 'package:flutter/material.dart';

class AppScaffold extends StatefulWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final bool? centerContent;
  final Widget? floatingActionButton;
  const AppScaffold({
    Key? key,
    required this.body,
    this.appBar,
    this.centerContent,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: widget.appBar,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            shrinkWrap: true,
            children: [
              widget.centerContent == true
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 40),
                            child: widget.body,
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 40),
                      child: widget.body,
                    ),
            ],
          ),
        ),
        floatingActionButton: widget.floatingActionButton,
      ),
    );
  }
}
