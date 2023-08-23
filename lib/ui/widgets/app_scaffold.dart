import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_toast_messages.dart';

class AppScaffold extends StatefulWidget {
  final Widget body;
  final AppBar? appBar;
  final bool? hasSidebar;
  final bool? centerContent;
  final FloatingActionButton? floatingActionButton;
  const AppScaffold({
    Key? key,
    required this.body,
    this.appBar,
    this.hasSidebar,
    this.centerContent,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.mobile) {
      AppToastMessage().showToastMsg("Připojení: ${_connectionStatus.toString()}", ToastState.success);
    } else if (result == ConnectivityResult.none) {
      AppToastMessage().showToastMsg("Žádné připojení: ${_connectionStatus.toString()}", ToastState.error);
    }
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
