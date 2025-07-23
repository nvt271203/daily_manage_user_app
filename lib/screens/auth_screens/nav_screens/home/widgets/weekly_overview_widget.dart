import 'package:daily_manage_user_app/helpers/tools_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyOverview extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const WeeklyOverview({super.key, required this.onDateSelected});

  @override
  _WeeklyOverviewState createState() => _WeeklyOverviewState();
}

class _WeeklyOverviewState extends State<WeeklyOverview> {
  late DateTime _today;
  late DateTime _selectedDate;
  late DateTime _currentMonday;
  late List<DateTime> _weekDates;
  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _selectedDate = _today;
    _currentMonday = _getStartOfWeek(_today);
    _weekDates = _generateWeekDates(_currentMonday);
  }

  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  List<DateTime> _generateWeekDates(DateTime start) {
    return List.generate(7, (index) => start.add(Duration(days: index)));
  }

  void _goToPreviousWeek() {
    setState(() {
      _currentMonday = _currentMonday.subtract(Duration(days: 7));
      _weekDates = _generateWeekDates(_currentMonday);
      // _selectedDate = _weekDates[3];
    });
  }

  void _goToNextWeek() {
    setState(() {
      _currentMonday = _currentMonday.add(Duration(days: 7));
      _weekDates = _generateWeekDates(_currentMonday);
      // _selectedDate = _weekDates[3];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            // offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.only(left: 20),
                child: Text(
                  "Weekly Overview",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Text(
                DateFormat('MMMM yyyy').format(_currentMonday),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Dates Row
          Row(
            children: [
              InkWell(
                onTap: _goToPreviousWeek,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: HelpersColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(Icons.chevron_left, color: HelpersColors.primaryColor),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // print("Chiều rộng hiện tại: ${constraints.maxWidth}");
                    // Tính tổng chiều rộng các item (ví dụ mỗi item là 70)
                    // const double itemWidth = 42;
                    // final double totalItemWidth = itemWidth * 7;

                    // Nếu đủ chỗ, không cần scroll
                    // if (constraints.maxWidth >= totalItemWidth) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (index) {
                          DateTime date = _weekDates[index];

                          bool isSelected = DateFormat('yyyy-MM-dd').format(date) ==
                              DateFormat('yyyy-MM-dd').format(_selectedDate);

                          String day = DateFormat('E').format(date);
                          String dayNum = DateFormat('dd').format(date);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = date;
                                widget.onDateSelected(date);
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  day,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding:  EdgeInsets.symmetric(
                                    vertical: constraints.maxWidth >= 300 ? 10 : 7,
                                    horizontal: constraints.maxWidth >= 300 ? 12 : 9
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? LinearGradient(
                                      colors: [
                                        Color(0xFF5D5FEF),
                                        Color(0xFFCB6CE6),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )
                                        : null,
                                    borderRadius: constraints.maxWidth >= 300 ? BorderRadius.circular(14) : BorderRadius.circular(10),
                                    color: isSelected ? null : Colors.transparent,
                                  ),
                                  child: Text(
                                    dayNum,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.grey[800],
                                      fontSize: constraints.maxWidth >= 300 ? 16 : 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );

                    //
                    // } else{
                    //
                    //
                    //   return SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: List.generate(7, (index) {
                    //         DateTime date = _weekDates[index];
                    //
                    //         bool isSelected = DateFormat('yyyy-MM-dd').format(date) ==
                    //             DateFormat('yyyy-MM-dd').format(_selectedDate);
                    //
                    //         String day = DateFormat('E').format(date);
                    //         String dayNum = DateFormat('dd').format(date);
                    //
                    //         return GestureDetector(
                    //           onTap: () {
                    //             setState(() {
                    //               _selectedDate = date;
                    //             });
                    //           },
                    //           child: Column(
                    //             children: [
                    //               Text(
                    //                 day,
                    //                 style: TextStyle(
                    //                   fontSize: 13,
                    //                   fontWeight: FontWeight.w500,
                    //                   color: Colors.grey[600],
                    //                 ),
                    //               ),
                    //               const SizedBox(height: 6),
                    //               Container(
                    //                 padding: const EdgeInsets.symmetric(
                    //                   vertical: 10,
                    //                   horizontal: 12,
                    //                 ),
                    //                 decoration: BoxDecoration(
                    //                   gradient: isSelected
                    //                       ? LinearGradient(
                    //                     colors: [
                    //                       Color(0xFF5D5FEF),
                    //                       Color(0xFFCB6CE6),
                    //                     ],
                    //                     begin: Alignment.topCenter,
                    //                     end: Alignment.bottomCenter,
                    //                   )
                    //                       : null,
                    //                   borderRadius: BorderRadius.circular(14),
                    //                   color: isSelected ? null : Colors.transparent,
                    //                 ),
                    //                 child: Text(
                    //                   dayNum,
                    //                   style: TextStyle(
                    //                     color: isSelected ? Colors.white : Colors.grey[800],
                    //                     fontSize: 16,
                    //                     fontWeight: FontWeight.bold,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         );
                    //       }),
                    //     ),
                    //   );
                    //
                    // }
                  },
                ),
              ),
              SizedBox(width: 10,),

              InkWell(
                onTap: _goToNextWeek,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: HelpersColors.primaryColor.withOpacity(0.1),
                  ),
                  child: Icon(Icons.chevron_right_outlined, color: HelpersColors.primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
