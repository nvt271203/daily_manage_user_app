import 'package:daily_manage_user_app/controller/work_controller.dart';
import 'package:daily_manage_user_app/screens/common_screens/widgets/top_notification_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../helpers/tools_colors.dart';

class CheckSaveMissionDialog extends StatefulWidget {
  const CheckSaveMissionDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.report,
    required this.plan,
    required this.note,
    // required this.idWork
  });

  // final String title;
  final String report;
  final String plan;
  final String note;

  // final String idWork;
  final Future<bool> Function() onConfirm;

  // final Future<bool> Function() onCancel;
  final VoidCallback onCancel;

  @override
  State<CheckSaveMissionDialog> createState() => _CheckSaveMissionDialogState();
}

class _CheckSaveMissionDialogState extends State<CheckSaveMissionDialog> {
  bool _isLoading = false;

  // void _handleConfirm() async {
  //   setState(() => _isLoading = true);
  //
  //   final success = await WorkController().updateWorkByUser(
  //     // id: widget.idWork,
  //     report: widget.report,
  //     plan: widget.plan,
  //     note: widget.note, id: '',
  //   );
  //   if (success) {
  //     showTopNotification(
  //       context: context,
  //       message: 'Save success',
  //       type: NotificationType.success,
  //     );
  //     await widget.onConfirm();
  //   } else {
  //     showTopNotification(
  //       context: context,
  //       message: 'Save fail',
  //       type: NotificationType.error,
  //     );
  //   }
  //   setState(() => _isLoading = false);
  //
  //   if (success) {
  //     Navigator.pop(context, true); // đóng dialog
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: HelpersColors.primaryColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Text(
              'Are you sure ?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Do you want to save the changes?',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Buttons
                // Buttons or Loading
                _isLoading
                    ? const CircularProgressIndicator()
                    : Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                widget.onCancel();
                                // Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HelpersColors.itemSelected,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Don\'t Save',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              // onPressed: _handleConfirm,
                              // onPressed: () {
                              //   FocusScope.of(context).unfocus(); // 👈 Thêm dòng này
                              //   Navigator.pop(context);
                              //   widget.onConfirm();
                              // },
                              onPressed: () async {
                                FocusScope.of(context).unfocus(); // Đóng bàn phím

                                setState(() => _isLoading = true); // Show loading indicator
                                final success = await widget.onConfirm(); // Chờ xử lý

                                setState(() => _isLoading = false);

                                // if (success) {
                                //   if (mounted) Navigator.pop(context); // Chỉ pop khi thành công & context còn tồn tại
                                // }
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: HelpersColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
