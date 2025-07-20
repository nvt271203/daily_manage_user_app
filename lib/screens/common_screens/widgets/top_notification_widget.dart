import 'package:daily_manage_user_app/helpers/tools_colors.dart';
import 'package:flutter/material.dart';

enum NotificationType { success, error }

void showTopNotification({
  required BuildContext context,
  required String message,
  required NotificationType type,
  Duration duration = const Duration(seconds: 3),
}) {
  final overlay = Overlay.of(context);
  final theme = Theme.of(context);

  final isSuccess = type == NotificationType.success;
  final backgroundColor = isSuccess ? const Color(0xFFE3F2FD) : const Color(0xFFFFEBEE);
  final contentColor = isSuccess ? HelpersColors.primaryColor : HelpersColors.itemSelected;
  final iconData = isSuccess ? Icons.check_circle_outline : Icons.error_outline;

  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: _NotificationContent(
          message: message,
          icon: iconData,
          backgroundColor: backgroundColor,
          contentColor: contentColor,
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(duration, () => overlayEntry.remove());
}

class _NotificationContent extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color contentColor;

  const _NotificationContent({
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: Offset(0, 0),
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(6),
              child: Icon(
                icon,
                color: contentColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: contentColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
