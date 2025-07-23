import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../../helpers/format_helper.dart';
import '../../../../../../helpers/tools_colors.dart';
class BodyTopCurrentTime extends StatefulWidget {
  BodyTopCurrentTime({super.key});

  @override
  State<BodyTopCurrentTime> createState() => _BodyTopCurrentTimeState();
}

class _BodyTopCurrentTimeState extends State<BodyTopCurrentTime> {
  DateTime _now = DateTime.now();
  Timer? _timer;
  Duration _checkInDuration = Duration.zero;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Bắt đầu timer cập nhật mỗi giây
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
    _startCheckInTimer();
  }
  void _startCheckInTimer() {
      setState(() {
        _checkInDuration += Duration(seconds: 1);
      });
  }

  @override
  Widget build(BuildContext context) {
    return           Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Lottie.asset('assets/lotties/robot_primary.json', width: 100),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // Thêm mainAxisAlignment để căn giữa cả nhóm
              children: [
                Text(
                  // 'Thứ năm',
                  FormatHelper.formatWeekdayEN(_now),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                Text(
                  ' - ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
                Text(
                  // '26/06/2025',
                  FormatHelper.formatDate_DD_MM_YYYY(_now),
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Align(
              child: Text(
                // '9:00 AM',
                FormatHelper.formatTimeVN(_now),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: HelpersColors.itemPrimary,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
