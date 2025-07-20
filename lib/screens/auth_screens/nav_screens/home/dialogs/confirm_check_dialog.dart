import 'dart:async';
import 'package:daily_manage_user_app/helpers/tools_colors.dart';
import 'package:flutter/material.dart';

import '../../../../common_screens/widgets/top_notification_widget.dart';
enum CheckType { checkIn, checkOut }
class ConfirmCheckDialog extends StatefulWidget {
  final String title;
  final CheckType type;
  final String Function() contentBuilder;
  final VoidCallback onConfirm;

  const ConfirmCheckDialog({
    super.key,
    required this.title,
    required this.contentBuilder,
    required this.onConfirm,
    required this.type,

  });

  @override
  State<ConfirmCheckDialog> createState() => _DialogConfirmWidgetState();
}

class _DialogConfirmWidgetState extends State<ConfirmCheckDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Cập nhật lại UI mỗi giây để nội dung động (thời gian) luôn được làm mới
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy timer khi đóng dialog
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = widget.type == CheckType.checkIn;
    final background = isSuccess ? HelpersColors.primaryColor : HelpersColors.itemSelected;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Nội dung
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              children: [
                Text(
                  widget.contentBuilder(), // Nội dung cập nhật theo thời gian thực
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: background),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: background),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // // Nhấn xác nhận confim phát là đóng, thì ok r, đóng để xử lý các tiến trình tiếp
                          // Navigator.pop(context);
                          // // ✅ Đóng dialog sau khi xử lý xong
                          // widget.onConfirm();   // 🟡 Gọi và CHỜ xử lý xong
                          // Navigator.pop(context, true); // Truy kết quả về cho cha
                          // Navigator.pop(context);
                          widget.onConfirm();

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
