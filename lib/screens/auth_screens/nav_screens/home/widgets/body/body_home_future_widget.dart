import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class BodyHomeFutureWidget extends StatelessWidget {
  const BodyHomeFutureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Lottie.asset('assets/lotties/404_page.json', width: 300),
    );  }
}
