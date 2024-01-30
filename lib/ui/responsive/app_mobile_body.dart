import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../modules/settings/view/settings_page.dart';
import '../../modules/trade/view/trade_list_page.dart';
import '../../modules/vineyard/view/vineyard_list_page.dart';
import '../../modules/wine/view/wine_list_page.dart';
import '../../services/app_preferences.dart';
import '../../services/dependency_injection.dart';

class AppMobileBody extends StatefulWidget {
  const AppMobileBody({super.key});

  @override
  State<AppMobileBody> createState() => _AppMobileBodyState();
}

class _AppMobileBodyState extends State<AppMobileBody> {
  late AppPreferences appPreferences = instance<AppPreferences>();
  final user = FirebaseAuth.instance.currentUser;
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    const WineListPage(),
    const VineyardListPage(),
    const TradeListPage(),
    const SettingsPage(),
  ];

  void _onPageTap(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: _onPageTap,
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.wine,
            icon: const Icon(Icons.wine_bar),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.vineyard,
            icon: const Icon(Icons.local_florist),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.trade,
            icon: const Icon(Icons.swap_horiz),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.settings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
