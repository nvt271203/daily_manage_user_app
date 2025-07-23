import 'package:daily_manage_user_app/providers/user_provider.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/work_chart/sub_nav_work_bar_chart_screen.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/work_board/sub_nav_work_board_screen.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/sub_nav_work_gantt_screen.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/widgets/header_sub_nav_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import '../../../../../../../helpers/tools_colors.dart';
import '../../../../../../../models/work.dart';

class WidgetToFrom extends StatelessWidget {
  final List<Work> works;
  final DateTime startDate;
  final DateTime endDate;

  const WidgetToFrom({
    super.key,
    required this.works,
    required this.startDate,
    required this.endDate,
  });

  // Hàm hiển thị các thứ.
  String _weekdayFromDate(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }
  // Hàm thống kê
  Widget buildSummary(List<Map<String, dynamic>> chartData) {
    final totalMinutes = chartData.fold<double>(
      0,
          (sum, e) => sum + (e['minutes'] as double),
    );
    final totalHours = totalMinutes ~/ 60;
    final remainMinutes = totalMinutes % 60;

    final sorted = chartData.where((e) => e['minutes'] > 0).toList()
      ..sort((a, b) => (b['minutes'] as double).compareTo(a['minutes'] as double));

    final mostDay = sorted.isNotEmpty ? sorted.first : null;
    final leastDay = sorted.length > 1 ? sorted.last : null;
    final workedDays = chartData.where((e) => e['minutes'] > 0).length;

    TextStyle titleStyle = const TextStyle(fontWeight: FontWeight.w600, fontSize: 14);
    TextStyle valueStyle = const TextStyle(color: Colors.black87, fontSize: 14);

    Widget row(IconData icon, String label, String value, {Color? iconColor}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: iconColor ?? Colors.blueAccent),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: valueStyle,
                  children: [
                    TextSpan(text: "$label: ", style: titleStyle),
                    TextSpan(text: value),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0EDFF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row(Icons.access_time, "Total working time in month", "$totalHours : ${remainMinutes.toInt()}"),
          if (mostDay != null)
            row(Icons.trending_up, "Most working day", "Day ${mostDay['day']} - ${_formatHourMinute(mostDay['minutes'])}", iconColor: Colors.green),
          if (leastDay != null)
            row(Icons.trending_down, "Least working day", "Day ${leastDay['day']} - ${_formatHourMinute(leastDay['minutes'])}", iconColor: Colors.redAccent),
          row(Icons.calendar_today, "Number of working days", "$workedDays / ${chartData.length} days"),
        ],
      ),
    );
  }

  //
  String _formatHourMinute(double minutes) {
    final totalMinutes = minutes.round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}";
  }
  @override
  Widget build(BuildContext context) {
    final filteredWorks = works.where((work) {
      final checkIn = work.checkInTime.toLocal();
      return !checkIn.isBefore(startDate) && !checkIn.isAfter(endDate);
    }).toList();
    final ScrollController scrollController = ScrollController();
    final groupedData = _groupDataByDate(filteredWorks);
    final sortedDates = _generateDateRange(startDate, endDate);
    // Tạo dữ liệu cho thống kê.

    final chartData = sortedDates.map((date) {
      final minutes = (groupedData[date] ?? 0) / 60.0;
      return {
        'day': date.day,
        'minutes': minutes,
      };
    }).toList();



    final barWidth = 40.0; // mỗi cột rộng 40
    final chartWidth = sortedDates.length * barWidth + 32; // padding nhỏ

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: chartWidth,
                    child: BarChart(
                      BarChartData(
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            // tooltipBgColor: Colors.black87,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final hours = rod.toY.floor();
                              final minutes = ((rod.toY - hours) * 60).round();
                              return BarTooltipItem(
                                '${hours.toString().padLeft(2, '0')}h${minutes.toString().padLeft(2, '0')}',
                                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                              );
                            },
                            tooltipPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),

                        ),

                        // clipData: FlClipData.none, // ✅ Tắt clipping để cột không bị cắt



                        alignment: BarChartAlignment.spaceAround,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 30,
                              getTitlesWidget: (value, _) => Text(
                                "${value.toInt()}h",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 60, // ✅ Thêm dòng này để cấp đủ không gian---------------------------
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 && index < sortedDates.length) {
                                  final date = sortedDates[index];
                                  final String weekday = _weekdayFromDate(
                                    date.weekday,
                                  ); // => 'Mon', 'Tue', etc.
                                  return SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Column(
                                      children: [
                                        Text(
                                          weekday, // 🆕 Thứ trong tuần: Mon, Tue,...
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "${date.day}/${date.month}",
                                          style: const TextStyle(fontSize: 10),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                              interval: 1,
                            ),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(show: true, drawVerticalLine: false),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(sortedDates.length, (index) {
                          final date = sortedDates[index];
                          final totalSeconds = groupedData[date] ?? 0;
                          final totalHours = totalSeconds / 3600;

                          // Dùng cho tollip hiển thị tổng giờ
                          final minutes = chartData[index]['minutes'] as double;
                          final hours = (minutes / 60).toDouble();

                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: totalHours,
                                color: HelpersColors.itemPrimary,
                                borderRadius: BorderRadius.circular(4),
                                width: 20, // spacing nhỏ giữa các cột
                                // width: barWidth - 10, // spacing nhỏ giữa các cột
                              ),
                            ],
                            showingTooltipIndicators: hours > 0 ? [0] : [],

                          );
                        }),
                        // maxY: _calculateMaxY(groupedData.values.toList()),
                        maxY: _calculateMaxY(groupedData.values.toList()),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // 📝 ĐÃ THÊM: khoảng cách
            buildSummary(chartData),
            SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }

  Map<DateTime, double> _groupDataByDate(List<Work> works) {
    final Map<DateTime, double> grouped = {};
    for (var work in works) {
      final date = DateTime(
        work.checkInTime.year,
        work.checkInTime.month,
        work.checkInTime.day,
      );
      grouped[date] = (grouped[date] ?? 0) + work.workTime.inSeconds.toDouble();
    }
    return grouped;
  }

  List<DateTime> _generateDateRange(DateTime start, DateTime end) {
    final List<DateTime> days = [];
    DateTime current = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);
    while (!current.isAfter(endDate)) {
      days.add(current);
      current = current.add(Duration(days: 1));
    }
    return days;
  }

  double  _calculateMaxY(List<double> values) {
    if (values.isEmpty) return 10;
    final maxValue = values.reduce(max);
    //
    final hours = maxValue /3600;
    // Cộng 1 khoảng padding
    // return (maxValue / 3600).ceilToDouble().clamp(1, 24); // in hours
    return (hours * 1.3).ceilToDouble().clamp(1, 24); // Thêm 20% đệm

  }
}
