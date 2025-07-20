import 'package:daily_manage_user_app/providers/user_provider.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/work_chart/sub_nav_work_bar_chart_screen.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/work_board/sub_nav_work_board_screen.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/sub_nav_work_gantt_screen.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/widgets/header_sub_nav_widget.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/work_chart/tab_work_chart/week/widgets/weekly_work_chart_widget.dart';
import 'package:daily_manage_user_app/widgets/loading_status_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:month_year_picker/month_year_picker.dart';

import '../../../../../../../../helpers/tools_colors.dart';
import '../../../../../../../../models/work.dart';
import '../../../../../../../../providers/work_provider.dart';

class WeeklyNavigatorWidget extends ConsumerStatefulWidget {
  const WeeklyNavigatorWidget({super.key});

  @override
  _WeeklyNavigatorWidgetState createState() => _WeeklyNavigatorWidgetState();
}

class _WeeklyNavigatorWidgetState extends ConsumerState<WeeklyNavigatorWidget> {
  late DateTime currentWeekStartDate;
  late DateTime _selectedDate;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//--------------------
  late int currentMonth;
  late int currentYear;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(workProvider.notifier).fetchWorks());
    currentWeekStartDate = _getStartOfWeek(DateTime.now());
    _selectedDate = DateTime.now();
//--------------------

    final now = DateTime.now();
    currentMonth = now.month;
    currentYear = now.year;
    currentWeekStartDate = _getStartOfWeek(now);
    _selectedDate = now;
    Future.microtask(() => ref.read(workProvider.notifier).fetchWorks());
  }

  DateTime _getStartOfWeek(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);

    // // Nếu là thứ Hai thì dùng luôn
    // if (date.weekday == DateTime.monday) {
    //   return DateTime(date.year, date.month, date.day);
    // }
    //
    // // Ngược lại, chuyển sang thứ Hai của tuần tiếp theo
    // final daysToAdd = 8 - date.weekday;
    // final nextMonday = date.add(Duration(days: daysToAdd));
    // return DateTime(nextMonday.year, nextMonday.month, nextMonday.day);

  }

  void _goToPreviousWeek() {
    setState(() {
      // currentWeekStartDate = currentWeekStartDate.subtract(const Duration(days: 7));
      // _selectedDate = currentWeekStartDate;
      currentWeekStartDate = currentWeekStartDate.subtract(const Duration(days: 7));
      _selectedDate = currentWeekStartDate;
      currentMonth = currentWeekStartDate.month;
      currentYear = currentWeekStartDate.year;
    });
  }

  void _goToNextWeek() {
    setState(() {
      // currentWeekStartDate = currentWeekStartDate.add(const Duration(days: 7));
      // _selectedDate = currentWeekStartDate;
      currentWeekStartDate = currentWeekStartDate.add(const Duration(days: 7));
      _selectedDate = currentWeekStartDate;
      currentMonth = currentWeekStartDate.month;
      currentYear = currentWeekStartDate.year;
    });
  }

  List<Work> _filterWorksByWeek(List<Work> works) {
    final weekEnd = currentWeekStartDate.add(const Duration(days: 7));
    return works.where((work) {
      final date = work.checkInTime.toLocal();
      return date.isAfter(currentWeekStartDate.subtract(const Duration(seconds: 1))) &&
          date.isBefore(weekEnd);
    }).toList();
  }


  void _showMonthYearPickerDialog() {
    int selectedMonth = currentMonth;
    int selectedYear = currentYear;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text(
                'Select Month & Year',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Dropdown tháng
                      DropdownButton<int>(
                        value: selectedMonth,
                        items: List.generate(12, (index) {
                          return DropdownMenuItem(
                            value: index + 1,
                            child: Text('${index + 1}'.padLeft(2, '0')),
                          );
                        }),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedMonth = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 20),
                      // Dropdown năm
                      DropdownButton<int>(
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
                    ],
                  ),
                ],
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
                      currentMonth = selectedMonth;
                      currentYear = selectedYear;

                      DateTime firstDayOfMonth = DateTime(currentYear, currentMonth, 1);
                      currentWeekStartDate = _getStartOfWeek(firstDayOfMonth);
                      _selectedDate = currentWeekStartDate;
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



  @override
  Widget build(BuildContext context) {
    final allWorksAsync = ref.watch(workProvider);

    return allWorksAsync.when(
      data: (allWorks) {
        final weekWorks = _filterWorksByWeek(allWorks);

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: _showMonthYearPickerDialog,
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
                        Text('Month $currentMonth / $currentYear',
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
                const SizedBox(height: 10),
                _buildWeekNavigator(),
                const SizedBox(height: 16),
                Expanded(
                  child: WeeklyWorkChartWidget(
                    works: weekWorks,
                    startOfWeek: currentWeekStartDate,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: LoadingStatusBarWidget()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Lỗi tải dữ liệu: $err')),
      ),
    );
  }

  // Widget _buildDatePicker(BuildContext context) {
  //   return InkWell(
  //     onTap: () async {
  //       final picked = await showDatePicker(
  //         context: context,
  //         firstDate: DateTime(2000),
  //         lastDate: DateTime(2026),
  //       );
  //       if (picked != null || picked != _selectedDate) {
  //         setState(() {
  //           _selectedDate = picked!;
  //           currentWeekStartDate = _getStartOfWeek(picked);
  //         });
  //       }
  //     },
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       decoration: BoxDecoration(color: HelpersColors.bgFillTextField),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Icon(Icons.calendar_today, color: HelpersColors.itemPrimary),
  //           SizedBox(width: 10),
  //           Text(
  //             _formatDateDayMonthYear(_selectedDate),
  //             style: TextStyle(
  //               color: HelpersColors.itemPrimary,
  //               fontSize: 14,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           SizedBox(width: 10),
  //           Icon(Icons.arrow_drop_down, color: HelpersColors.itemPrimary),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildWeekNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: HelpersColors.bgFillTextField,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: IconButton(
            onPressed: _goToPreviousWeek,
            icon: Icon(Icons.chevron_left, color: HelpersColors.itemPrimary),
          ),
        ),
        SizedBox(width: 20),
        Column(
          children: [
            Text('Week', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "${_formatDate(currentWeekStartDate)} - ${_formatDate(currentWeekStartDate.add(const Duration(days: 6)))}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(width: 20),
        Container(
          decoration: BoxDecoration(
            color: HelpersColors.bgFillTextField,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: IconButton(
            onPressed: _goToNextWeek,
            icon: Icon(Icons.chevron_right, color: HelpersColors.itemPrimary),
          ),
        ),
      ],
    );
  }


  // Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required Widget targetScreen}) {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => targetScreen),
  //             (route) => false,
  //       );
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           color: HelpersColors.bgFillTextField,
  //           borderRadius: BorderRadius.circular(16),
  //           boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
  //         ),
  //         child: ListTile(
  //           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //           leading: Container(
  //             decoration: BoxDecoration(
  //               color: Colors.blue.withOpacity(0.2),
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             padding: EdgeInsets.all(8),
  //             child: Icon(icon, color: Colors.blue, size: 28),
  //           ),
  //           title: Text(
  //             title,
  //             style: TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //               color: HelpersColors.itemPrimary,
  //             ),
  //           ),
  //           trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18, color: HelpersColors.itemPrimary),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  String _formatDate(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}";

  String _formatDateDayMonthYear(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";

}
