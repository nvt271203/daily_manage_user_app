// monthly_work_chart_widget.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:daily_manage_user_app/models/work.dart';

class MonthlyWorkChartWidget extends StatelessWidget {
  final List<Work> works;
  final int year;
  final int month;

  const MonthlyWorkChartWidget({
    super.key,
    required this.works,
    required this.year,
    required this.month,
  });
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

  String _formatHourMinute(double minutes) {
    final totalMinutes = minutes.round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}";
  }

// Hàm hiển thị các thứ.
  String _weekdayFromDate(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final data = _buildChartData();
    // Biến kiểm tra trong mỗi tháng có làm tốn thời gian nào không
    final hasWorked = data.any((e) => e['minutes'] > 0);
    final maxY = _getMaxY(data);
    final ScrollController scrollController = ScrollController();
    if (!hasWorked) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today, size: 64, color: Colors.blueGrey), // 🆕 ICON thay thế
              const SizedBox(height: 12),
              const Text(
                "No Work Recorded Yet",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "You haven’t tracked any work this month. Stay focused and start logging your time to see your progress here!",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );


    }else {
      return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 320, // ✅ GÁN CHIỀU CAO CỐ ĐỊNH cho biểu đồ
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: data.length * 40 + 40,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxY,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipPadding: const EdgeInsets.all(8),
                          tooltipMargin: 8,
                          // 📝 ĐÃ THÊM: margin cho tooltip
                          tooltipBorder: BorderSide.none,
                          // 📝 ĐÃ THÊM: không viền
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            // final minutes = (rod.toY * 60).round();
                            final totalMinutes = (rod.toY * 60)
                                .round(); // 📝 ĐÃ SỬA: chuyển toY từ giờ sang phút
                            // final h = minutes ~/ 60;
                            // final m = minutes % 60;
                            final hours  = totalMinutes ~/ 60;
                            final minutes  = totalMinutes % 60;

                            return BarTooltipItem(
                              '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}', // 📝 ĐÃ SỬA: định dạng tooltip kiểu HH:mm
                              const TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,),

                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            reservedSize: 40, // Khoảng trống để hiển thị cả thứ và ngày.
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              final index = value.toInt();
                              if (index >= 0 && index < data.length) {

        // ----------------------------------------                        // Hiển thị các ngày trong tháng đó.
                                final int day = data[index]['day'];
                                final DateTime date = DateTime(year, month, day);
                                final String weekday = _weekdayFromDate(date.weekday); // => 'Mon', 'Tue', etc.
                                return SizedBox(
                                  height: 80,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        weekday, // 🆕 Thứ trong tuần: Mon, Tue,...
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '$day/$month', // Ngày trong tháng
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                );




    // ---------------------------------------                            // ----------------------------------------


                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (val, _) => Text('${val.toInt()}h'),
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(show: true, horizontalInterval: 1),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(data.length, (index) {
                        final minutes = data[index]['minutes'] as double;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: minutes / 60,
                              width: 18,
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.blueAccent,
                              // Nền background của các cột.
                              // backDrawRodData: BackgroundBarChartRodData(
                              //   show: true,
                              //   toY: maxY,
                              //   color: Colors.grey.withOpacity(0.1), // 📝 ĐÃ THÊM: nền cột để dễ so sánh
                              // ),

                            ),
                          ],
                          // Có hiển thị dữ liệu tổng giờ trên cột hay không, dựa vào cái này
                          showingTooltipIndicators: minutes > 0 ? [0] : [], // 📝 ĐÃ THÊM: chỉ hiện tooltip nếu có dữ liệu
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16), // 📝 ĐÃ THÊM: khoảng cách
          buildSummary(data),
        ],
      ),
    );
    }
  }
// Tạo ra 1 hàm lấy về tổng số ngày và tổng thời gian làm việc của từng ngày
//   [
  //   { 'day': 1, 'minutes': 480.0 },
  //   { 'day': 2, 'minutes': 0.0 },
  //   { 'day': 3, 'minutes': 375.0 },
  //   ...
//   ]
  List<Map<String, dynamic>> _buildChartData() {
    // Lấy ra tổng số ngày trong 1 tháng: 30 or 31
    final daysInMonth = DateUtils.getDaysInMonth(year, month);

    return List.generate(daysInMonth, (i) {

// Tạo DateTime cho từng ngày (từ ngày 1 đến ngày N).
      final day = DateTime(year, month, i + 1);
      final totalSeconds = works
          .where((w) {
            final d = w.checkInTime.toLocal();
            return d.year == year && d.month == month && d.day == day.day;
          })
          .fold<int>(0, (sum, w) => sum + w.workTime.inSeconds);

      return {'day': i + 1, 'minutes': (totalSeconds / 60).toDouble()};
    });
  }

  double _getMaxY(List<Map<String, dynamic>> data) {
    final maxMinutes = data
        .map((e) => e['minutes'] as double)
        .fold(0.0, (a, b) => a > b ? a : b);
    final maxHour = (maxMinutes / 60).ceil();
    return maxHour < 10 ? 10 : maxHour + 1;
  }
}
