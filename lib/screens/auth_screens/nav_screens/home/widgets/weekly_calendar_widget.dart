import 'package:daily_manage_user_app/helpers/tools_colors.dart';
import 'package:flutter/material.dart';

class WeeklyCalendarWidget extends StatelessWidget {
  final DateTime currentDate;

  const WeeklyCalendarWidget({
    super.key,
    required this.currentDate,
  });

  @override
  Widget build(BuildContext context) {
    final int currentWeekday = currentDate.weekday;
    final DateTime startOfWeek =
    currentDate.subtract(Duration(days: currentWeekday - 1));

    final List<DateTime> weekDates =
    List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    const double cellWidth = 40;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      child: Column(
        children: [
          // Header thứ trong tuần
          Container(
            color: HelpersColors.primaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'].map((label) {
                  return SizedBox(
                    width: cellWidth,
                    child: Center(
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Hàng ngày
          Container(
            color: HelpersColors.itemTextField.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: weekDates.map((date) {
                  final bool isToday = date.day == currentDate.day &&
                      date.month == currentDate.month &&
                      date.year == currentDate.year;

                  final int weekday = date.weekday; // 1 (T2) đến 7 (CN)
                  final bool isWeekend = weekday == 6 || weekday == 7;

                  Color backgroundColor;
                  BoxBorder? border;

                  if (isToday) {
                    // Ngày hôm nay
                    backgroundColor = isWeekend
                        ? Colors.grey.shade300
                        : HelpersColors.itemPrimary.withOpacity(0.5); // Tô xanh đậm hoặc xám
                    border = Border.all(
                      color: Colors.red.shade800, // Viền đỏ đậm
                      width: 3.0,
                    );
                  } else {
                    // Ngày không phải hôm nay
                    backgroundColor = isWeekend
                        ? Colors.grey.shade300
                        : Colors.lightBlue.shade100;
                    border = null;
                  }

                  return SizedBox(
                    width: cellWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: cellWidth,
                          height: cellWidth,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            shape: BoxShape.circle,
                            border: border,
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                color: isToday ? Colors.black : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        if (isToday)
                          const SizedBox(height: 4),
                        if (isToday)
                           Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 12,
                              color: HelpersColors.itemSelected,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),

                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
