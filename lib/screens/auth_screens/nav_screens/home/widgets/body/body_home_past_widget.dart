import 'package:daily_manage_user_app/helpers/format_helper.dart';
import 'package:daily_manage_user_app/helpers/tools_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class BodyHomePastWidget extends StatelessWidget {
  const BodyHomePastWidget({super.key, required this.dateTime});
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,),
        Container(
          child: Lottie.asset('assets/lotties/Bussiness.json', width: 300),
        ),
        Text('Work History on ${FormatHelper.formatDate_DD_MM_YYYY(dateTime)}',style: TextStyle(fontSize: 16,color: HelpersColors.itemPrimary,fontWeight: FontWeight.bold),),

      ],
    );
  }
}
