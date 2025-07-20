import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:daily_manage_user_app/helpers/tools_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth_screens/nav_screens/account/account_screen.dart';
import 'auth_screens/nav_screens/history/history_screen.dart';
import 'auth_screens/nav_screens/home/home_screen.dart';
import 'auth_screens/nav_screens/leave/leave_screen.dart';



class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _page = [
    HomeScreen(),
    HistoryScreen(),
    LeaveScreen(),
    AccountScreen()
  ];
  // BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
  //   bool isSelected = _pageIndex == index;
  //   return BottomNavigationBarItem(
  //     label: '',
  //     icon: Container(
  //       // padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), // ✅ Giảm lại padding
  //       // margin: const EdgeInsets.symmetric(vertical: 8),
  //       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
  //       decoration: BoxDecoration(
  //         // color: isSelected ? Colors.blue : Colors.transparent,
  //         gradient: LinearGradient(colors: isSelected ? [
  //           HelpersColors.primaryColor, HelpersColors.secondaryColor
  //         ] : [Colors.transparent, Colors.transparent]),
  //
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Icon(icon, color: isSelected ? Colors.white : const Color(0xFF4E709B)),
  //           const SizedBox(height: 4),
  //           Text(
  //             label,
  //             style: TextStyle(
  //               color: isSelected ? Colors.white : const Color(0xFF4E709B),
  //               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
  //               fontSize: 13,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //
  //   );
  // }
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
                  child: Icon(Icons.history,size: _currentIndex == 1 ? 35 : 30,color: _currentIndex == 1 ?  Colors.white : Colors.blueGrey),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.description,size: _currentIndex == 2 ? 35 : 30,color: _currentIndex == 2 ?  Colors.white : Colors.blueGrey),
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


  // @override
  // Widget build(BuildContext context) {
  //   List<Widget> _pages = [
  //     HomeScreen(),
  //     HistoryScreen(),
  //     LeaveScreen(),
  //     AccountScreen(),
  //   ];
  //   return Scaffold(
  //     bottomNavigationBar: BottomNavigationBar(
  //       currentIndex: _pageIndex,
  //       onTap: (value) {
  //         setState(() {
  //           _pageIndex = value;
  //         });
  //       },
  //       // selectedItemColor: Colors.blue,
  //       // unselectedItemColor: Color(0xFF4E709B),
  //       unselectedItemColor: Colors.blueGrey,
  //       // backgroundColor: Color(0xFFDAEAFF),
  //       backgroundColor: Color(0xFFDAEAFF),
  //       showSelectedLabels: false,      // ✅ Ẩn label đã chọn
  //       showUnselectedLabels: false,    // ✅ Ẩn label chưa chọn
  //
  //       selectedLabelStyle: const TextStyle(
  //         fontWeight: FontWeight.bold,
  //         fontSize: 14,
  //       ),
  //       unselectedLabelStyle: const TextStyle(
  //         fontWeight: FontWeight.normal,
  //         fontSize: 13,
  //       ),
  //       type: BottomNavigationBarType.fixed,
  //       items: [
  //         // BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
  //         // BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
  //         // BottomNavigationBarItem(
  //         //   icon: Icon(Icons.close_rounded),
  //         //   label: "Leave",
  //         // ),
  //         // BottomNavigationBarItem(
  //         //   icon: Icon(CupertinoIcons.person_fill),
  //         //   label: "Account",
  //         // ),
  //
  //         _buildNavItem(Icons.home, "Home", 0),
  //         _buildNavItem(Icons.history, "History", 1),
  //         _buildNavItem(Icons.close_rounded, "Leave", 2),
  //         _buildNavItem(CupertinoIcons.person_fill, "Account", 3),
  //       ],
  //     ),
  //     body: _pages[_pageIndex],
  //   );
  // }
}
