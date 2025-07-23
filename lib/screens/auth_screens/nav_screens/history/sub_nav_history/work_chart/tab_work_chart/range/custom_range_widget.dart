import 'package:daily_manage_user_app/helpers/format_helper.dart';
import 'package:daily_manage_user_app/helpers/tools_colors.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/work_chart/widgets/widget_to_from.dart';
import 'package:daily_manage_user_app/screens/common_screens/widgets/top_notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../providers/work_provider.dart';

class CustomRangeWidget extends ConsumerStatefulWidget {
  const CustomRangeWidget({super.key});

  @override
  _CustomRangeWidgetState createState() => _CustomRangeWidgetState();
}

class _CustomRangeWidgetState extends ConsumerState<CustomRangeWidget> {
  DateTime? _selectedDateStart;
  DateTime? _selectedDateEnd;
  bool _errorStartDate = false;
  String _textErrorDayStart = 'Day start is required';

  Future<void> _pickDateStart() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateStart ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      locale: const Locale('en'), // ✅ Đặt ngôn ngữ thành tiếng Anh
    );

    if (picked != null) {
      if (_selectedDateEnd != null && picked.isAfter(_selectedDateEnd!)) {
        showTopNotification(context: context, message: 'Start date cannot be after end date.', type: NotificationType.error);
        return;
      }

      setState(() {
        _selectedDateStart = picked;
      });
    }
  }

  Future<void> _pickDateEnd() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateEnd ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      locale: const Locale('en'), // ✅ Đặt ngôn ngữ thành tiếng Anh
    );

    if (picked != null) {
      if (_selectedDateStart != null && picked.isBefore(_selectedDateStart!)) {
        showTopNotification(context: context, message: 'End date cannot be before start date.', type: NotificationType.error);
        return;
      }

      setState(() {
        _selectedDateEnd = picked;
      });
    }
  }


  Widget _buildTextTitle({required String title}) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: HelpersColors.primaryColor, fontSize: 15),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {




    final worksAsync = ref.watch(workProvider);

    return
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextTitle(title: 'Choose start day'),
                  InkWell(
                    onTap: () {
                      _pickDateStart();
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                            color: HelpersColors.bgFillTextField,
                            border: Border.all(
                              color: _errorStartDate
                                  ? HelpersColors.itemSelected
                                  : HelpersColors.bgFillTextField,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today),
                              SizedBox(width: 10),
                              Text(
                                _selectedDateStart == null
                                    ? 'Choose Day Start'
                                    : FormatHelper.formatDate_DD_MM_YYYY(
                                        _selectedDateStart!,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        if (_errorStartDate)
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              _textErrorDayStart,
                              style: TextStyle(color: HelpersColors.itemSelected),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                    ),
                SizedBox(width: 20,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextTitle(title: 'Choose end day'),
                    InkWell(
                      onTap: () {
                        _pickDateEnd();
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              color: HelpersColors.bgFillTextField,
                              border: Border.all(
                                color: _errorStartDate
                                    ? HelpersColors.itemSelected
                                    : HelpersColors.bgFillTextField,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today),
                                SizedBox(width: 10),
                                Text(
                                  _selectedDateEnd == null
                                      ? 'Choose Day End'
                                      : FormatHelper.formatDate_DD_MM_YYYY(
                                    _selectedDateEnd!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_errorStartDate)
                            Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                _textErrorDayStart,
                                style: TextStyle(color: HelpersColors.itemSelected),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

              ],
            ),
            const SizedBox(height: 20),
            if (_selectedDateStart != null && _selectedDateEnd != null)
              worksAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text("Error: $err"),
                data: (works) {
                  // // Lọc works trong khoảng thời gian
                  // final filteredWorks = works.where((work) {
                  //   return work.checkInTime.isAfter(_selectedDateStart!.subtract(const Duration(days: 1))) &&
                  //       work.checkInTime.isBefore(_selectedDateEnd!.add(const Duration(days: 1)));
                  // }).toList();
                  final filteredWorks = works.where((work) {
                    final checkIn = work.checkInTime.toLocal();
                    final checkOut = checkIn.add(work.workTime);

                    // Có giao nhau với khoảng đã chọn không?
                    return !(checkOut.isBefore(_selectedDateStart!) || checkIn.isAfter(_selectedDateEnd!));
                  }).toList();



                  if (filteredWorks.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.calendar_today, size: 64, color: Colors.blueGrey),
                            SizedBox(height: 12),
                            Text(
                              "No Work Recorded This Month",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Start logging your working hours to see your monthly performance here!",
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

                  }

                  return WidgetToFrom(
                    startDate: _selectedDateStart!,
                    endDate: _selectedDateEnd!,
                    works: filteredWorks,
                  );
                },
              ),
          ],
        ),
      );
  }
}
