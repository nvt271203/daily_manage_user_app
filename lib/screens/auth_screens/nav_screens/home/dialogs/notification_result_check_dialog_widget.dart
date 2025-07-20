import 'package:flutter/material.dart';

class NotificationResultCheckDialogWidget extends StatefulWidget {
  final String title;
  final DateTime time;
  final String message;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onClose;

  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final Duration? workDuration;

  const NotificationResultCheckDialogWidget({
    Key? key,
    required this.title,
    required this.time,
    required this.message,
    required this.iconColor,
    required this.icon,
    required this.onClose,
    this.checkInTime,
    this.checkOutTime,
    this.workDuration,
  }) : super(key: key);

  @override
  State<NotificationResultCheckDialogWidget> createState() => _CheckStatusFinishDialogWidgetState();
}

class _CheckStatusFinishDialogWidgetState extends State<NotificationResultCheckDialogWidget> {
  String _formatTime(DateTime time) {
    final local = time.toLocal();
    return "${local.hour.toString().padLeft(2, '0')}:"
        "${local.minute.toString().padLeft(2, '0')}:"
        "${local.second.toString().padLeft(2, '0')}";
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 10,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Icon tròn nổi bật
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.iconColor.withOpacity(0.15),
              ),
              child: Icon(widget.icon, size: 50, color: widget.iconColor),
            ),
            const SizedBox(height: 16),

            /// Tiêu đề
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 6),

            /// Thời gian chính
            Text(
              _formatTime(widget.time),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 10),

            /// Thông điệp phụ
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),

            /// Nếu là check out thì hiển thị thêm
            if (widget.title.toLowerCase().contains('out') &&
                widget.checkInTime != null &&
                widget.checkOutTime != null &&
                widget.workDuration != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(thickness: 1.2),
                    const SizedBox(height: 8),
                    _buildInfoRow("Check In:", _formatTime(widget.checkInTime!)),
                    _buildInfoRow("Check Out:", _formatTime(widget.checkOutTime!)),
                    _buildInfoRow("Total Worked:", _formatDuration(widget.workDuration!), isHighlight: true),
                    const SizedBox(height: 8),
                    Divider(thickness: 1.2),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            /// Nút OK
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onClose();
                  // widget.onClose;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "OK",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Hàm helper: dòng thông tin
  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                color: isHighlight ? Colors.blueAccent : Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w400,
              color: isHighlight ? Colors.blueAccent : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
