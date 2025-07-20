import 'package:flutter/material.dart';
class CustomRangeWidget extends StatefulWidget {
  const CustomRangeWidget({super.key});

  @override
  State<CustomRangeWidget> createState() => _CustomRangeWidgetState();
}

class _CustomRangeWidgetState extends State<CustomRangeWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Custom Range'),
    );
  }
}
