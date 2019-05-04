import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget Function(BuildContext) buildTablet;
  final Widget Function(BuildContext) buildPhone;

  ResponsiveContainer(this.buildTablet, this.buildPhone);

  @override
  Widget build(BuildContext context) {
    return isTablet(context) ? buildTablet(context) : buildPhone(context);
  }

  static bool isTablet(BuildContext context) {
    // The equivalent of the "smallestWidth" qualifier on Android.
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    // Determine if we should use mobile layout or not. The
    // number 600 here is a common breakpoint for a typical
    // 7-inch tablet.
    final bool useMobileLayout = shortestSide < 600;
    return !useMobileLayout;
  }
}
