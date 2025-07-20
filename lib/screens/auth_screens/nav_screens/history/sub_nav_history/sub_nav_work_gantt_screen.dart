// import 'package:daily_manage_user_app/providers/user_provider.dart';
// import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/work_chart/sub_nav_work_bar_chart_screen.dart';
// import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/work_board/sub_nav_work_board_screen.dart';
// import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/widgets/header_sub_nav_widget.dart';
// import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/widgets/work_gant_chart_content.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../../helpers/tools_colors.dart';
// import '../../../../../models/work.dart';
// import '../../account/account_screen.dart';
// import '../../home/home_screen.dart';
// import '../../leave/leave_screen.dart';
// class SubNavWorkGanttScreen extends ConsumerStatefulWidget {
//   const SubNavWorkGanttScreen({super.key});
//
//   @override
//   _SubNavWorkGanttScreenState createState() => _SubNavWorkGanttScreenState();
// }
//
// class _SubNavWorkGanttScreenState extends ConsumerState<SubNavWorkGanttScreen> {
//   int _pageIndex = 1;
//   late DateTime currentWeekStartDate;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
//     bool isSelected = _pageIndex == index;
//     return BottomNavigationBarItem(
//       label: '',
//       icon: Container(
//         // padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), // ✅ Giảm lại padding
//         // margin: const EdgeInsets.symmetric(vertical: 8),
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//         decoration: BoxDecoration(
//           // color: isSelected ? Colors.blue : Colors.transparent,
//           gradient: LinearGradient(colors: isSelected ? [
//             HelpersColors.primaryColor, HelpersColors.secondaryColor
//           ] : [Colors.transparent, Colors.transparent]),
//
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, color: isSelected ? Colors.white : const Color(0xFF4E709B)),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 color: isSelected ? Colors.white : const Color(0xFF4E709B),
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ),
//       ),
//
//     );
//   }
//   List<Work> _filterWorksByWeek(List<Work> works) {
//     final weekEnd = currentWeekStartDate.add(const Duration(days: 7));
//     return works.where((work) {
//       final date = work.checkInTime;
//       return date.isAfter(currentWeekStartDate.subtract(const Duration(seconds: 1))) &&
//           date.isBefore(weekEnd);
//     }).toList();
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     currentWeekStartDate = _getStartOfWeek(DateTime.now());
//
//   }
//   DateTime _getStartOfWeek(DateTime date) {
//     return date.subtract(Duration(days: date.weekday - 1));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Work> testWorks = [
//       Work(
//         id: '1',
//         checkInTime: DateTime.parse('2025-06-24T08:00:00Z').toLocal(),
//         checkOutTime: DateTime.parse('2025-06-24T12:00:00Z').toLocal(),
//         workTime: Duration(hours: 4),
//         report: 'Hoàn thành module A',
//         plan: 'Làm module A',
//         result: 'Đã xong',
//         userId: 'user_1',
//       ),
//       Work(
//         id: '2',
//         checkInTime: DateTime.parse('2025-06-25T09:00:00Z').toLocal(),
//         checkOutTime: DateTime.parse('2025-06-25T11:30:00Z').toLocal(),
//         workTime: Duration(hours: 2, minutes: 30),
//         report: 'Họp team',
//         plan: 'Họp',
//         result: 'OK',
//         userId: 'user_1',
//       ),
//       Work(
//         id: '3',
//         checkInTime: DateTime.parse('2025-06-26T13:00:00Z').toLocal(),
//         checkOutTime: DateTime.parse('2025-06-26T17:45:00Z').toLocal(),
//         workTime: Duration(hours: 4, minutes: 45),
//         report: 'Fix bug',
//         plan: 'Fix lỗi hệ thống',
//         result: 'Tạm ổn',
//         userId: 'user_1',
//       ),
//       Work(
//         id: '4',
//         checkInTime: DateTime.parse('2025-06-27T08:30:00Z').toLocal(),
//         checkOutTime: DateTime.parse('2025-06-27T10:00:00Z').toLocal(),
//         workTime: Duration(hours: 1, minutes: 30),
//         report: 'Code UI',
//         plan: 'Xây dựng giao diện',
//         result: 'Xong',
//         userId: 'user_1',
//       ),
//       Work(
//         id: '5',
//         checkInTime: DateTime.parse('2025-06-28T07:00:00Z').toLocal(),
//         checkOutTime: DateTime.parse('2025-06-28T09:00:00Z').toLocal(),
//         workTime: Duration(hours: 2),
//         report: 'Viết tài liệu',
//         plan: 'Viết doc',
//         result: 'OK',
//         userId: 'user_1',
//       ),
//       Work(
//         id: '6',
//         checkInTime: DateTime.parse('2025-06-29T14:00:00Z').toLocal(),
//         checkOutTime: DateTime.parse('2025-06-29T18:00:00Z').toLocal(),
//         workTime: Duration(hours: 4),
//         report: 'Kiểm thử',
//         plan: 'Test hệ thống',
//         result: 'Passed',
//         userId: 'user_1',
//       ),
//       Work(
//         id: '7',
//         checkInTime: DateTime.parse('2025-06-30T10:00:00Z').toLocal(),
//         checkOutTime: DateTime.parse('2025-06-30T15:00:00Z').toLocal(),
//         workTime: Duration(hours: 5),
//         report: 'Tổng hợp báo cáo',
//         plan: 'Soạn báo cáo tháng',
//         result: 'Hoàn tất',
//         userId: 'user_1',
//       ),
//     ];
//     final user = ref.read(userProvider);
//     // final allWorks = ref.watch(workProvider);
//     final weekWorks = _filterWorksByWeek(testWorks);
//
//
//
//
//     List<Widget> _pages = [
//       HomeScreen(),
//       // SubNavWorkGranttScreen(),
//       // WorkGantChart(works: testWorks, startOfWeek: currentWeekStartDate),
//       WorkGantChartContent(),
//
//       LeaveScreen(),
//       AccountScreen(),
//     ];
//     return Scaffold(
//       appBar: _pageIndex == 1
//           ? PreferredSize(
//         preferredSize: const Size.fromHeight(60),
//         child: HeaderSubNavWidget(
//           title: 'Work Gantt',
//           onMenuPressed: () {
//             _scaffoldKey.currentState?.openDrawer();
//           },
//         ),
//       )
//           : null, // Các page khác không có appBar
//       key: _scaffoldKey,
//       drawer: Drawer(
//         child: Container(
//           color: Colors.white,
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16.0,
//                   vertical: 24.0,
//                 ),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [HelpersColors.itemPrimary, Colors.grey],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 50,),
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.all(Radius.circular(100)),
//                           ),
//                           child: ClipRRect(
//                               borderRadius: BorderRadiusGeometry.all(Radius.circular(50)),
//                               child:
//                               user?.image == null || user!.image.isEmpty
//                                   ? Image.asset(
//                                 user?.sex == 'Male'
//                                     ? 'assets/images/avatar_boy_default.jpg'
//                                     : 'assets/images/avatar_girl_default.jpg',
//                                 width: 50,
//                                 height: 50,
//                                 fit: BoxFit.cover,
//                               )
//                                   : Image.network(
//                                 user.image,
//                                 width: 50,
//                                 height: 50,
//                               )
//
//
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             user!.fullName,
//                             style: const TextStyle(
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             softWrap: true,
//                             maxLines: 2,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       user.email,
//                       style: TextStyle(color: Colors.white70, fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//               //
//               SizedBox(height: 10),
//
//               InkWell(
//                 onTap: () {
//                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
//                     return SubNavWorkBarChartScreen();
//                   },), (route) => false,);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: HelpersColors.bgFillTextField,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 6,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       leading: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.blue.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: EdgeInsets.all(8),
//                         child: Icon(
//                           Icons.bar_chart_rounded,
//                           color: Colors.blue,
//                           size: 28,
//                         ),
//                       ),
//                       title: Text(
//                         'Work Chart',
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: HelpersColors.itemPrimary
//                         ),
//                       ),
//                       trailing: Icon(
//                         Icons.arrow_forward_ios_rounded,
//                         size: 18,
//                         color: HelpersColors.itemPrimary,
//                       ),
//
//                     ),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
//                     return SubNavWorkBoardScreen();
//                   },), (route) => false,);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: HelpersColors.bgFillTextField,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 6,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       leading: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.blue.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: EdgeInsets.all(8),
//                         child: Icon(
//                           Icons.dashboard_customize_outlined,
//                           color: Colors.blue,
//                           size: 28,
//                         ),
//                       ),
//                       title: Text(
//                         'Work Board',
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: HelpersColors.itemPrimary
//                         ),
//                       ),
//                       trailing: Icon(
//                         Icons.arrow_forward_ios_rounded,
//                         size: 18,
//                         color: HelpersColors.itemPrimary,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
//                     return SubNavWorkGanttScreen();
//                   },), (route) => false,);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: HelpersColors.bgFillTextField,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 6,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       leading: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.blue.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: EdgeInsets.all(8),
//                         child: Icon(
//                           Icons.view_timeline_outlined,
//                           color: Colors.blue,
//                           size: 28,
//                         ),
//                       ),
//                       title: Text(
//                         'Work Gantt',
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: HelpersColors.itemPrimary
//                         ),
//                       ),
//                       trailing: Icon(
//                         Icons.arrow_forward_ios_rounded,
//                         size: 18,
//                         color: HelpersColors.itemPrimary,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//
//             ],
//           ),
//         ),
//       ),
//
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _pageIndex,
//         onTap: (value) {
//           setState(() {
//             _pageIndex = value;
//           });
//         },
//         // selectedItemColor: Colors.blue,
//         // unselectedItemColor: Color(0xFF4E709B),
//         unselectedItemColor: Colors.blueGrey,
//         // backgroundColor: Color(0xFFDAEAFF),
//         backgroundColor: Color(0xFFDAEAFF),
//         showSelectedLabels: false,      // ✅ Ẩn label đã chọn
//         showUnselectedLabels: false,    // ✅ Ẩn label chưa chọn
//
//         selectedLabelStyle: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 14,
//         ),
//         unselectedLabelStyle: const TextStyle(
//           fontWeight: FontWeight.normal,
//           fontSize: 13,
//         ),
//         type: BottomNavigationBarType.fixed,
//         items: [
//           // BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           // BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
//           // BottomNavigationBarItem(
//           //   icon: Icon(Icons.close_rounded),
//           //   label: "Leave",
//           // ),
//           // BottomNavigationBarItem(
//           //   icon: Icon(CupertinoIcons.person_fill),
//           //   label: "Account",
//           // ),
//
//           _buildNavItem(Icons.home, "Home", 0),
//           _buildNavItem(Icons.history, "History", 1),
//           _buildNavItem(Icons.close_rounded, "Leave", 2),
//           _buildNavItem(CupertinoIcons.person_fill, "Account", 3),
//         ],
//       ),
//       body: _pages[_pageIndex],
//     );
//
//   }
// }
