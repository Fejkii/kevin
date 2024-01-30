import 'package:flutter/material.dart';
import 'package:kevin/ui/responsive/app_desktop_body.dart';
import 'package:kevin/ui/responsive/app_mobile_body.dart';
import 'package:kevin/ui/responsive/app_responsive_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppResponsiveLayout(
        mobileBody: AppMobileBody(),
        desktopBody: AppDesktopBody(),
      ),
    );
  }
}
