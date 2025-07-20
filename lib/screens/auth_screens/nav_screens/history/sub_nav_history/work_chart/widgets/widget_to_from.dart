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

  @override
  Widget build(BuildContext context) {
    final filteredWorks = works.where((work) {
      final checkIn = work.checkInTime.toLocal();
      return !checkIn.isBefore(startDate) && !checkIn.isAfter(endDate);
    }).toList();

    final groupedData = _groupDataByDate(filteredWorks);
    final sortedDates = _generateDateRange(startDate, endDate);
    final barWidth = 40.0; // mỗi cột rộng 40
    final chartWidth = sortedDates.length * barWidth + 32; // padding nhỏ

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: chartWidth,
        height: 250,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, interval: 1, reservedSize: 30),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < sortedDates.length) {
                      final date = sortedDates[index];
                      return Text("${date.day}/${date.month}", style: const TextStyle(fontSize: 10));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  interval: 1,
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true, drawVerticalLine: false),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(sortedDates.length, (index) {
              final date = sortedDates[index];
              final totalSeconds = groupedData[date] ?? 0;
              final totalHours = totalSeconds / 3600;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: totalHours,
                    color: HelpersColors.itemPrimary,
                    borderRadius: BorderRadius.circular(4),
                    width: barWidth - 10, // spacing nhỏ giữa các cột
                  ),
                ],
              );
            }),
            maxY: _calculateMaxY(groupedData.values.toList()),
          ),
        ),
      ),
    );
  }


  Map<DateTime, double> _groupDataByDate(List<Work> works) {
    final Map<DateTime, double> grouped = {};
    for (var work in works) {
      final date = DateTime(work.checkInTime.year, work.checkInTime.month, work.checkInTime.day);
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

  double _calculateMaxY(List<double> values) {
    if (values.isEmpty) return 10;
    final maxValue = values.reduce(max);
    return (maxValue / 3600).ceilToDouble().clamp(1, 24); // in hours
  }
}

