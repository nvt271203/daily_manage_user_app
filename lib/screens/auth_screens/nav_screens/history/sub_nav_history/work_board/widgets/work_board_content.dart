import 'package:flutter/material.dart';

import '../../../../../../../helpers/tools_colors.dart';
import '../../../../../widgets/todo_list_table_widget.dart';

class WorkBoardContent extends StatefulWidget {
  const WorkBoardContent({super.key});

  @override
  State<WorkBoardContent> createState() => _WorkBoardContentState();
}

class _WorkBoardContentState extends State<WorkBoardContent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 🔷 Header mô tả phía trên
          // 🔷 Mô tả trang
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Icon bo tròn nhẹ, dễ nhìn
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(20),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  size: 50,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),

              // Tiêu đề
              const Text(
                "Work Tracking",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 5),

              // Mô tả
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "Track your daily check-in/check-out, work hours, and work progress",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          TodoListTableWidget(),
        ],
      ),
    );
  }
}
