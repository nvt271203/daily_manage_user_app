import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../models/work.dart';

class WeeklyWorkChartWidget extends StatelessWidget {
  final List<Work> works;
  final DateTime startOfWeek;

  const WeeklyWorkChartWidget({Key? key, required this.works, required this.startOfWeek})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("🟡 startOfWeek: $startOfWeek");
    final chartData = _convertToWeeklyChartData(works);
    final maxY = _getMaxY(chartData);

    // Kiểm tra tổng số phút làm việc trong tuần đó, nếu ko cs thì k hiển thị bản đồ
    final totalMinutes = chartData.fold<double>(
      0,
          (sum, e) => sum + (e['minutes'] as double),
    );
    if (totalMinutes == 0) {
      // ✅ Giao diện khi không có dữ liệu làm việc trong tuần
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.calendar_today, size: 64, color: Colors.blueGrey),
              SizedBox(height: 12),
              Text(
                "No Work Recorded This Week",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                "Start logging your working hours to see your weekly performance here!",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }else {
      return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      padding: const EdgeInsets.all(16),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
        builder: (context, value, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                // ✅ BIỂU ĐỒ
                SizedBox(
                  // height: 240,
                  height: 350,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxY,
                      // barTouchData: BarTouchData(enabled: false),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          // tooltipRoundedRadius: 8,
                          tooltipMargin: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final totalMinutes = (rod.toY * 60).round();
                            final hours = totalMinutes ~/ 60;
                            final minutes = totalMinutes % 60;
            
                            return BarTooltipItem(
                              "${hours.toString().padLeft(2, '0')}h${minutes.toString().padLeft(2, '0')}",
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            );
                          },
            
                          // getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          //   final hour = rod.toY;
                          //   return BarTooltipItem(
                          //     "${hour.toStringAsFixed(1)} h",
                          //     const TextStyle(
                          //       color: Colors.white,
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: 12,
                          //     ),
                          //   );
                          // },
                          tooltipPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          tooltipBorder: BorderSide.none,
                          // tooltipDecoration: BoxDecoration(
                          //   color: Colors.black87,
                          //   borderRadius: BorderRadius.circular(8),
                          // ),
                        ),
                      ),
            
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (x, _) {
                              final index = x.toInt();
                              if (index >= 0 && index < chartData.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        chartData[index]['weekday'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        chartData[index]['date'],
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
            
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 32,
                            getTitlesWidget: (value, _) => Text(
                              "${value.toInt()}h",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ), // font size trục Y
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        ),
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(chartData.length, (index) {
                        final minutes = chartData[index]['minutes'] as double;
                        final hours = (minutes / 60).toDouble();
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: hours * value,
                              width: 18,
                              borderRadius: BorderRadius.circular(4),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF42A5F5), Color(0xFF90CAF9)],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: maxY,
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),
                          ],
                          showingTooltipIndicators: hours > 0 ? [0] : [],
                        );
                      }),
                    ),
                  ),
                ),
            
                const SizedBox(height: 16),
            
                // ✅ THỐNG KÊ PHÍA DƯỚI
                buildSummary(chartData),
              ],
            ),
          );
        },
      ),
    );
    }
  }

  // List<Map<String, dynamic>> _convertToWeeklyChartData(List<Work> works) {
  //   final weekDates = List.generate(
  //     7,
  //     (i) => startOfWeek.add(Duration(days: i)),
  //   );
  //   // Hiển thị dữ liệu các ngày
  //   for (final day in weekDates) {
  //     print("📆 Day in week: ${day.toIso8601String()}");
  //   }
  //
  //   return weekDates.map((day) {
  //     final totalSeconds = works
  //         .where((w) {
  //           // ✅ Chuyển checkInTime từ UTC về Local để so sánh chính xác với ngày trong tuần
  //           final d = w.checkInTime.toLocal();
  //
  //           // final d = w.checkInTime;
  //
  //           return d.year == day.year &&
  //               d.month == day.month &&
  //               d.day == day.day;
  //         })
  //         .fold<int>(0, (sum, item) => sum + item.workTime.inSeconds);
  //
  //     //
  //     for (final w in works) {
  //       print(
  //         "✅ Work local: ${w.checkInTime.toLocal()} - duration: ${w.workTime}",
  //       );
  //     }
  //     ////
  //
  //     return {
  //       'weekday': _weekdayFromDate(day.weekday),
  //       'date':
  //           "${day.day.toString().padLeft(2, '0')}/${day.month.toString().padLeft(2, '0')}",
  //       'minutes': (totalSeconds / 60).toDouble(),
  //     };
  //   }).toList();
  // }
  List<Map<String, dynamic>> _convertToWeeklyChartData(List<Work> works) {
    final weekDates = List.generate(7, (i) => startOfWeek.add(Duration(days: i)));

    Map<String, double> minutesPerDay = {
      for (var day in weekDates)
        "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}": 0.0
    };

    for (final work in works) {
      DateTime checkIn = work.checkInTime.toLocal();
      DateTime checkOut = checkIn.add(work.workTime); // or work.checkOutTime.toLocal() if available

      DateTime current = checkIn;
      while (current.isBefore(checkOut)) {
        // final nextDay = DateTime(current.year, current.month, current.day + 1);
        final nextDay = DateTime(current.year, current.month, current.day).add(const Duration(days: 1));

        final endThisDay = checkOut.isBefore(nextDay) ? checkOut : nextDay;

        final workedDuration = endThisDay.difference(current);
        final key = "${current.year}-${current.month.toString().padLeft(2, '0')}-${current.day.toString().padLeft(2, '0')}";

        if (minutesPerDay.containsKey(key)) {
          minutesPerDay[key] = minutesPerDay[key]! + workedDuration.inMinutes.toDouble();
        }

        current = endThisDay;
      }
    }

    return weekDates.map((day) {
      final key = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
      return {
        'weekday': _weekdayFromDate(day.weekday),
        'date': "${day.day.toString().padLeft(2, '0')}/${day.month.toString().padLeft(2, '0')}",
        'minutes': minutesPerDay[key] ?? 0.0,
      };
    }).toList();
  }

  String _weekdayFromDate(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  double _getMaxY(List<Map<String, dynamic>> data) {
    final maxMin = data
        .map((e) => e['minutes'] as double)
        .fold(0.0, (a, b) => a > b ? a : b);
    final maxHour = (maxMin / 60).ceil();
    return maxHour < 10 ? 10 : maxHour + 1;
  }

  Widget buildSummary(List<Map<String, dynamic>> chartData) {
    final totalMinutes = chartData.fold<double>(
      0,
      (sum, e) => sum + (e['minutes'] as double),
    );
    final totalHours = totalMinutes ~/ 60;
    final remainMinutes = totalMinutes % 60;

    final sorted = chartData.where((e) => e['minutes'] > 0).toList()
      ..sort(
        (a, b) => (b['minutes'] as double).compareTo(a['minutes'] as double),
      );

    final mostDay = sorted.isNotEmpty ? sorted.first : null;
    final leastDay = sorted.length > 1 ? sorted.last : null;
    final workedDays = chartData
        .where((e) => (e['minutes'] as double) > 0)
        .length;

    TextStyle titleStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );
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
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0EDFF), // ✅ Nền dịu nhẹ
        borderRadius: BorderRadius.circular(12), // ✅ Bo góc
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ], // ✅ Đổ bóng nhẹ
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row(
            Icons.access_time,
            "Total working time per week",
            "${totalHours}h${remainMinutes.toInt()}",
          ),
          if (mostDay != null)
            row(
              Icons.trending_up,
              "Most working day",
              // "${mostDay['weekday']} (${(mostDay['minutes'] / 60).toStringAsFixed(1)} hours)",
              "${mostDay['weekday']} - ${_formatHourMinute(mostDay['minutes'])}",
              iconColor: Colors.green,
            ),
          if (leastDay != null)
            row(
              Icons.trending_down,
              "Least working day",
              // "${leastDay['weekday']} (${(leastDay['minutes'] / 60).toStringAsFixed(1)} hours)",
              "${leastDay['weekday']} - ${_formatHourMinute(leastDay['minutes'])}",
              iconColor: Colors.redAccent,
            ),
          row(
            Icons.calendar_today,
            "Number of working days",
            "$workedDays / 7 days",
          ),
        ],
      ),
    );
  }


  String _formatHourMinute(double minutes) {
    final totalMinutes = minutes.round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;

    return "${h.toString().padLeft(2, '0')}h${m.toString().padLeft(2, '0')}";
  }

}
