import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/vineyard/vineyard_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/ui/wine/wine_page.dart';

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
    const WinePage(),
    const VineyardPage(),
  ];

  void _onPageTap(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Column(
      //   children: [
      //     const Text("Home"),
      //     Text(user?.email ?? ""),
      //     Text(user?.uid ?? ""),
      //     Text(user?.displayName ?? ""),
      //     BlocConsumer<AuthBloc, AuthState>(
      //       listener: (context, state) {
      //         if (state is LoggedOutState) {
      //           Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signin, (route) => false);
      //         } else if (state is AuthFailureState) {
      //           Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signin, (route) => false);
      //         }
      //       },
      //       builder: (context, state) {
      //         if (state is AuthLoadingState) {
      //           return const AppLoadingIndicator();
      //         } else {
      //           return ListTile(
      //             leading: const Icon(Icons.logout),
      //             title: Text(AppLocalizations.of(context)!.logout),
      //             onTap: () {
      //               BlocProvider.of<AuthBloc>(context).add(const LogOutEvent());
      //             },
      //           );
      //         }
      //       },
      //     ),
      //     ElevatedButton(
      //       onPressed: () {
      //         BlocProvider.of<AuthBloc>(context).add(const LogOutEvent());
      //       },
      //       child: const Text("Odhlásit"),
      //     ),
      //   ],
      // ),
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
        ],
      ),
    );
  }
}
