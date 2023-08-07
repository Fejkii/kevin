import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kevin/modules/settings/view/settings_page.dart';
import 'package:kevin/modules/vineyard/view/vineyard_list_page.dart';
import 'package:kevin/modules/wine/view/wine_list_page.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppPreferences appPreferences = instance<AppPreferences>();
  final user = FirebaseAuth.instance.currentUser;
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    const WineListPage(),
    const VineyardListPage(),
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
            label: AppLocalizations.of(context)!.settings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
