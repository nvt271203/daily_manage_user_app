import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/widgets/work_gant_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../models/work.dart';
import '../../../../../../providers/work_provider.dart';
class WorkGantChartContent extends ConsumerStatefulWidget {
  const WorkGantChartContent({super.key});

  @override
  _WorkGantChartContentState createState() => _WorkGantChartContentState();
}

class _WorkGantChartContentState extends ConsumerState<WorkGantChartContent> {
  late DateTime currentWeekStartDate;
  @override
  void initState() {
    super.initState();
    currentWeekStartDate = _getStartOfWeek(DateTime.now());
  }



  // DateTime _getStartOfWeek(DateTime date) {
  //   return date.subtract(Duration(days: date.weekday - 1));
  // }
  DateTime _getStartOfWeek(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    print('StartDayFirst - ${DateTime(monday.year, monday.month, monday.day)}');

    return DateTime(monday.year, monday.month, monday.day); // reset về 00:00
  }

  void _goToPreviousWeek() {
    setState(() {
      currentWeekStartDate = currentWeekStartDate.subtract(const Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      currentWeekStartDate = currentWeekStartDate.add(const Duration(days: 7));
    });
  }
  List<Work> _filterWorksByWeek(List<Work> works) {
    final weekEnd = currentWeekStartDate.add(const Duration(days: 7));
    return works.where((work) {
      final date = work.checkInTime;
      return date.isAfter(currentWeekStartDate.subtract(const Duration(seconds: 1))) &&
          date.isBefore(weekEnd);
    }).toList();
  }



  @override
  Widget build(BuildContext context) {
    final allWorks = ref.watch(workProvider.notifier).fetchWorks();
    final weekWorks = _filterWorksByWeek(allWorks as List<Work>);



    return Scaffold(
      appBar: AppBar(title: const Text("Biểu đồ giờ làm việc")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔁 Nút chuyển tuần
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _goToPreviousWeek,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text(""),
                ),
                Text(
                  "Tuần ${_formatDate(currentWeekStartDate)} - ${_formatDate(currentWeekStartDate.add(const Duration(days: 6)))}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _goToNextWeek,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text(""),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: WorkGantChart(
                works: weekWorks,
                startOfWeek: currentWeekStartDate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}";

}
