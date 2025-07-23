import 'package:daily_manage_user_app/controller/connect_controller.dart';
import 'package:daily_manage_user_app/helpers/tools_colors.dart';
import 'package:daily_manage_user_app/screens/admin_main_screen.dart';
import 'package:daily_manage_user_app/screens/common_screens/widgets/splash_widget.dart';
import 'package:daily_manage_user_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/user_provider.dart';
import '../guest_screens/screens/login_screen.dart';
class SplashScreens extends ConsumerStatefulWidget {
  const SplashScreens({super.key});

  @override
  _SplashScreensState createState() => _SplashScreensState();
}

class _SplashScreensState extends ConsumerState<SplashScreens> {
  late Future<bool> futureCheckConnectBackend;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCheckConnectBackend = ConnectController().checkBackendConnection();
  }
  Future<void> _checkTokenAndUser(WidgetRef ref) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');
    String? userJson = preferences.getString('user');
    if(token != null &&  userJson != null){
      ref.read(userProvider.notifier).setUser(userJson);
    }else{
      ref.read(userProvider.notifier).signOut();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: futureCheckConnectBackend,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashWidget();
          }
          else if (snapshot.hasError || snapshot.data == false) {
            // ❌ Kết nối thất bại
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lotties/error.json', width: 200),
                  // nếu có animation lỗi
                  const SizedBox(height: 16),
                  const Text(
                    'Không kết nối được server.\nVui lòng thử lại.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureCheckConnectBackend = ConnectController()
                            .checkBackendConnection();
                      });
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          } else{
            // ✅ Kết nối thành công → chuyển sang màn chính
            // Future.microtask(() {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (_) => const MainScreen()),
            //   );
            // });
            // ⚠️ PHẢI return 1 widget trong builder
            return FutureBuilder(future: _checkTokenAndUser(ref), builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              final user = ref.read(userProvider);
              // return user!= null ? LeaveScreenTemp() :LeaveScreenTemp();
              // return user!= null ? AdminMainScreen() :AdminMainScreen();
              if (user == null) {
                return LoginScreen(); // chưa đăng nhập
              }
              // 👉 Phân nhánh theo role
              if (user.role == 'admin') {
                return AdminMainScreen(); // hoặc màn hình admin tương ứng
              } else {
                return MainScreen(); // user bình thường
              }
              // return user!= null ? MainScreen() :LoginScreen();
              // return user!= null ? SplashScreens() :LoginScreen();
              // return user!= null ? AdminRegisterScreen() :AdminRegisterScreen();
              // return user!= null ? NavigatorBottomBar() :NavigatorBottomBar();
              // return user!= null ? Responsive() :Responsive();
              // return user!= null ? LeaveTypeDropdown() :LeaveTypeDropdown();
            },);
          }
        },
      ),
    );
  }
}
