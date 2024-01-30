import 'package:flutter/material.dart';

class AppResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;

  const AppResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.desktopBody,
  });

  /// mobile < 650
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 650;

  /// tablet >= 650
  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 650;

  ///desktop >= 1100
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 650) {
          return mobileBody;
        } else {
          return desktopBody;
        }
      },
    );
  }
}
