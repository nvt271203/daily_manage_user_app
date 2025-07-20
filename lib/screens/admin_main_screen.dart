import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:daily_manage_user_app/screens/admin_screens/nav_screens/account/admin_account_screen.dart';
import 'package:daily_manage_user_app/screens/admin_screens/nav_screens/user/admin_user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/tools_colors.dart';
import 'admin_screens/nav_screens/home/admin_home_screen.dart';
import 'admin_screens/nav_screens/leave/admin_leave_screen.dart';
class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 2;
  final List<Widget> _page = [
    AdminHomeScreen(),
    AdminLeaveScreen(),
    AdminUserScreen(),
    AdminAccountScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        child: Scaffold(
          extendBody: true, // Quan trọng để thấy được phần phía sau thanh navigation
          // backgroundColor: HelpersColors.primaryColor,

          bottomNavigationBar: CurvedNavigationBar(
              index: _currentIndex,
              height: 60,
              // color: Colors.black.withOpacity(0.2), // màu nền navigator bar
              color: Color(0xFFC3C8E3).withOpacity(0.4), // màu nền navigator bar
              // color: Color(0xFFC3C8E3).withOpacity(0.4), // màu nền navigator bar
              buttonBackgroundColor: HelpersColors.primaryColor,  // màu nề item navigator bar được nhấn
              backgroundColor: Colors.transparent,
              onTap: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },

              items: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.home,size: _currentIndex == 0 ? 35 : 30,color: _currentIndex == 0 ?  Colors.white : Colors.blueGrey),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.description,size: _currentIndex == 1 ? 35 : 30,color: _currentIndex == 1 ?  Colors.white : Colors.blueGrey),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(CupertinoIcons.person_3_fill,size: _currentIndex == 2 ? 35 : 30,color: _currentIndex == 2 ?  Colors.white : Colors.blueGrey),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.person, size: _currentIndex == 3 ? 35 : 30,color: _currentIndex == 3 ?  Colors.white : Colors.blueGrey),
                )

              ]),
          body: _page[_currentIndex],
        ),
      ),
    );
  }
}
