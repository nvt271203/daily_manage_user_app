import 'package:flutter/material.dart';
import '../../../../../../helpers/tools_colors.dart';

class HeaderSubNavWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onMenuPressed;

  const HeaderSubNavWidget({
    super.key,
    required this.title,
    required this.onMenuPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.only(top: 24), // để tránh đè vào status bar
      decoration: BoxDecoration(
        color: HelpersColors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onMenuPressed,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 45,
                  height: 45,
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    icon,
                    color: HelpersColors.primaryColor,
                  ),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 45), // giữ khoảng trống đối xứng bên phải
            ],
          ),
        ),
      ),
    );
  }
}
