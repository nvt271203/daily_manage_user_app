import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/home/widgets/body/body_home_future_widget.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/home/widgets/body/body_home_past_widget.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/home/widgets/body/body_home_present_widget.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/home/widgets/body/body_top_current_time.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/home/widgets/header_home_widget.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/home/widgets/weekly_overview_widget.dart';
import 'package:daily_manage_user_app/screens/auth_screens/widgets/todo_list_table_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now(); // mặc định là hôm nay

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }
  bool _isPastDay(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(DateTime(now.year, now.month, now.day));
  }
  // bool _isFutureDay(DateTime date) {
  //   final today = DateTime.now();
  //   final dateOnly = DateTime(today.year, today.month, today.day);
  //   return date.isAfter(dateOnly);
  // }
  bool _isFutureDay(DateTime date) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dateOnly.isAfter(todayOnly);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
                    children: [
                      HeaderHomeWidget(),
                      WeeklyOverview(
                        onDateSelected: (dateSelected) {
                          print('dateSelected - ${dateSelected.day}');
                          setState(() {
                            _selectedDate = dateSelected;
                          });
                        },
                      ),
                      BodyTopCurrentTime(),
                      if (_isToday(_selectedDate)) BodyHomePresentWidget(),
                      if (_isPastDay(_selectedDate)) BodyHomePastWidget(dateTime: _selectedDate,),
                      if (_isFutureDay(_selectedDate)) BodyHomeFutureWidget(),
                      SizedBox(height: 20,),
                      TodoListTableWidget(selectedDate: _selectedDate,)
                    ]),
          ),
        ),
      ),
    );
  }
}
