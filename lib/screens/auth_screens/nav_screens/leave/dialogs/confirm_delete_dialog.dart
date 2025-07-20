import 'package:flutter/material.dart';
import 'package:daily_manage_user_app/helpers/tools_colors.dart';

class ConfirmDeleteDialog extends StatefulWidget {
  final String title;
  final String content;
  // Taị vì muốn có loading để thể hiện quá trình chờ xóa data load dữ liệu, nên mới cần Future.
  final Future<bool> Function(String reason) onConfirm; // ⬅️ cập nhật kiểu dữ liệu



  const ConfirmDeleteDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  State<ConfirmDeleteDialog> createState() => _ConfirmDeleteDialogState();
}

class _ConfirmDeleteDialogState extends State<ConfirmDeleteDialog> {
  final TextEditingController controllerReason = TextEditingController();
  String? errorText;
  bool _isLoading = false;

  // void _handleConfirm() {
  //   final reason = controllerReason.text.trim();
  //   if (reason.isEmpty) {
  //     setState(() {
  //       errorText = 'Reason is required!';
  //     });
  //     return;
  //   }
  //
  //   widget.onConfirm();
  //   // Navigator.pop(context); // đóng dialog nếu hợp lệ
  // }
  void _handleConfirm() async {
    final reason = controllerReason.text.trim();
    if (reason.isEmpty) {
      setState(() {
        errorText = 'Reason is required!';
      });
      return;
    }

    setState(() => _isLoading = true);

    final success = await widget.onConfirm(reason);

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context, true); // đóng dialog
    }
  }

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
              color: HelpersColors.itemSelected,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Text(
              widget.title,
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.content,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // TextField nhập lý do
                TextField(
                  controller: controllerReason,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Enter reason for delete request...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    errorText: errorText,
                    isDense: true,
                    contentPadding: const EdgeInsets.all(10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: HelpersColors.itemPrimary,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.redAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.redAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                // Buttons or Loading
                _isLoading
                    ? const CircularProgressIndicator()
                    : Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: HelpersColors.itemSelected),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: HelpersColors.itemSelected),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _handleConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HelpersColors.itemSelected,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Confirm',
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
