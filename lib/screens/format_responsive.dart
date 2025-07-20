import 'package:flutter/material.dart';
class FormatResponsive extends StatefulWidget {
  const FormatResponsive({super.key, required this.desktopWidget, required this.tabletWidget, required this.mobileWidget});
  final Widget desktopWidget;
  final Widget tabletWidget;
  final Widget mobileWidget;

  @override
  State<FormatResponsive> createState() => _FormatResponsiveState();
}

class _FormatResponsiveState extends State<FormatResponsive> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      print('👉 maxWidth = ${constraints.maxWidth}');
      if (constraints.maxWidth >= 1024) {
        return widget.desktopWidget;
      } else if (constraints.maxWidth < 1024 &&
          constraints.maxWidth >= 768) {
        return widget.tabletWidget;
      } else {
        return widget.mobileWidget;
      }
    },);
  }
}
