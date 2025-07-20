import 'package:daily_manage_user_app/helpers/tools_colors.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/work_chart/tab_work_chart/week/weekly_navigator_widget.dart';
import 'package:flutter/material.dart';

import '../tab_work_chart/month/monthly_navigator_widget.dart';
import '../tab_work_chart/range/custom_range_widget.dart';

class WorkChartContent extends StatefulWidget {
  const WorkChartContent({super.key});

  @override
  State<WorkChartContent> createState() => _WorkChartContentState();
}

class _WorkChartContentState extends State<WorkChartContent> {
  int _selectedIndex = 0;
  final List<IconData> _tabIcons = [
    Icons.calendar_view_week,
    Icons.calendar_month,
    Icons.date_range,
  ];

  final List<String> _tabs = ["Week", "Month", "Range"];
  final List<Widget> _tabContents = [
    const WeeklyNavigatorWidget(),
    const MonthlyNavigatorWidget(),
    const CustomRangeWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                color: HelpersColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                'Working Time Chart',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: HelpersColors.primaryColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Thanh điều hướng tab
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: HelpersColors.primaryColor,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: List.generate(_tabs.length, (index) {
                final isSelected = _selectedIndex == index;
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? HelpersColors.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ]
                          : [],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _tabIcons[index],
                                size: 18,
                                color: isSelected ? Colors.white : Colors.black.withOpacity(0.7),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _tabs[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black.withOpacity(0.7),
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),

        // const SizedBox(height: 16),

        // Expanded(child: const WeeklyNavigatorWidget()),
        Expanded(child: _tabContents[_selectedIndex]),
      ],
    );
  }
}
