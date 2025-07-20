// monthly_navigator_widget.dart
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/work_chart/tab_work_chart/month/widgets/monthly_work_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_manage_user_app/models/work.dart';
import 'package:daily_manage_user_app/providers/work_provider.dart';
import 'package:daily_manage_user_app/widgets/loading_status_bar_widget.dart';
import 'package:daily_manage_user_app/helpers/tools_colors.dart';

class MonthlyNavigatorWidget extends ConsumerStatefulWidget {
  const MonthlyNavigatorWidget({super.key});

  @override
  ConsumerState<MonthlyNavigatorWidget> createState() => _MonthlyNavigatorWidgetState();
}

class _MonthlyNavigatorWidgetState extends ConsumerState<MonthlyNavigatorWidget> {
  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    Future.microtask(() => ref.read(workProvider.notifier).fetchWorks());
  }
  void _showYearPickerDialog() {
    int selectedYear = currentYear;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text(
                'Select Year',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: DropdownButton<int>(
                value: selectedYear,
                items: List.generate(10, (index) {
                  final year = DateTime.now().year - 5 + index;
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() {
                      selectedYear = value;
                    });
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      currentYear = selectedYear;

                      DateTime firstDayOfYear = DateTime(currentYear, 1, 1);
                      // currentWeekStartDate = _getStartOfWeek(firstDayOfYear);
                      // _selectedDate = currentWeekStartDate;
                    });
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }









  void _goToPreviousMonth() {
    setState(() {
      if (currentMonth == 1) {
        currentMonth = 12;
        currentYear--;
      } else {
        currentMonth--;
      }
    });
  }

  void _goToNextMonth() {
    setState(() {
      if(currentMonth == 12){
        currentMonth = 1;
        currentYear++;
      }else{
        currentMonth++;
      }
    });
  }

  void _showMonthPicker() {
    int tempMonth = currentMonth;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: const Text('Select Month'),
              content: DropdownButton<int>(
                value: currentMonth,
                items: List.generate(12, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text('Month ${index + 1}'),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() {
                      tempMonth = value;
                    });
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentMonth = tempMonth;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final allWorksAsync = ref.watch(workProvider);

    return allWorksAsync.when(
      data: (allWorks) {
        final filtered = allWorks.where((w) {
          final d = w.checkInTime.toLocal();
          return d.month == currentMonth && d.year == currentYear;
        }).toList();

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                Expanded(
                  child: MonthlyWorkChartWidget(
                    works: filtered,
                    year: currentYear,
                    month: currentMonth,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: LoadingStatusBarWidget())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Lỗi: $err'))),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        InkWell(
          onTap: _showYearPickerDialog,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: HelpersColors.bgFillTextField,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.date_range, color: HelpersColors.itemPrimary),
                SizedBox(width: 8),
                Text('Year $currentYear',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: HelpersColors.itemPrimary,
                    )),
                SizedBox(width: 16),
                Icon(Icons.keyboard_arrow_down,color: HelpersColors.itemPrimary,)
              ],
            ),
          ),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: HelpersColors.bgFillTextField,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: IconButton(
                onPressed: _goToPreviousMonth,
                icon: Icon(Icons.chevron_left, color: HelpersColors.itemPrimary),
              ),
            ),
            SizedBox(width: 20,),
            InkWell(
              onTap: _showMonthPicker,
              child: Row(
                children: [
                  Text('Month ${currentMonth}', style: TextStyle(fontWeight: FontWeight.bold)),
                 Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ),
            SizedBox(width: 20,),

            Container(
              decoration: BoxDecoration(
                color: HelpersColors.bgFillTextField,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: IconButton(
                onPressed: _goToNextMonth,
                icon: Icon(Icons.chevron_right, color: HelpersColors.itemPrimary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
