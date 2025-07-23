import 'package:daily_manage_user_app/providers/user_provider.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/work_board/widgets/work_board_content.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/work_chart/sub_nav_work_bar_chart_screen.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/work_board/sub_nav_work_board_screen.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/sub_nav_work_gantt_screen.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/widgets/header_sub_nav_widget.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/history/sub_nav_history/work_chart/tab_work_chart/week/widgets/weekly_work_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../helpers/tools_colors.dart';
import '../../../../models/work.dart';
import '../../../../providers/work_provider.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter/services.dart'; // nhớ thêm import này nếu chưa có

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _tabIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ✅ Đặt màu thanh trạng thái trùng với AppBar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, // màu AppBar
      statusBarIconBrightness: Brightness.dark, // icon trắng
    ));
  }

  Widget _buildDrawer(user) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [HelpersColors.itemPrimary, Colors.grey],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Row(
                    children: [
                      Container(
                        // padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: user?.image == null || user!.image.isEmpty
                              ? Image.asset(
                                  user?.sex == 'Male'
                                      ? 'assets/images/avatar_boy_default.jpg'
                                 : user?.sex == 'Male'
                                      ? 'assets/images/avatar_girl_default.jpg'
                            : 'assets/images/avt_default_2.jpg',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  user.image,
                                  width: 50,
                                  height: 50,
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          (user?.fullName == null || user!.fullName.trim().isEmpty)
                              ? 'New User'
                              : user.fullName,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            _buildDrawerItem(
              context,
              icon: Icons.dashboard_customize_outlined,
              title: 'Work Board',
              targetScreen: SubNavWorkBoardScreen(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.bar_chart_rounded,
              title: 'Work Chart',
              targetScreen: SubNavWorkBarChartScreen(),
            ),

            // _buildDrawerItem(
            //   context,
            //   icon: Icons.view_timeline_outlined,
            //   title: 'Work Gantt',
            //   targetScreen: SubNavWorkGanttScreen(),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget targetScreen,


  }) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: HelpersColors.bgFillTextField,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(8),
              child: Icon(icon, color: Colors.blue, size: 28),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: HelpersColors.itemPrimary,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: HelpersColors.itemPrimary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);

    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(user),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: HeaderSubNavWidget(
          title: 'Work Board',
          icon: Icons.dashboard_customize_outlined,
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: SingleChildScrollView(
        // child: Column(children: [WorkBoardContent()]),
        child: Column(children: [WorkBoardContent()]),

      ),
    );
  }
}
