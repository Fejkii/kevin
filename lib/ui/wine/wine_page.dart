import 'package:flutter/material.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WinePage extends StatefulWidget {
  const WinePage({super.key});

  @override
  State<WinePage> createState() => _WinePageState();
}

class _WinePageState extends State<WinePage> {
  final AppPreferences appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Column(
          children: [
            const Text("Wine page"),
            Text(appPreferences.getUser().email),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.wine),
        actions: [
          IconButton(
            onPressed: () {
              // TODO
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const VineyardDetailView(),
              //   ),
              // ).then((value) => _getData());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
