import 'package:daily_manage_user_app/providers/user_provider.dart';
import 'package:daily_manage_user_app/screens/common_screens/splash_screens.dart';
import 'package:daily_manage_user_app/screens/common_screens/widgets/splash_next_screen_widget.dart';
import 'package:daily_manage_user_app/screens/common_screens/widgets/splash_widget.dart';
import 'package:daily_manage_user_app/screens/guest_screens/screens/admin_register_screen.dart';
import 'package:daily_manage_user_app/screens/main_screen.dart';
import 'package:daily_manage_user_app/screens/responsive.dart';
import 'package:daily_manage_user_app/screens/temp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

void main() async{
  // Chặn xoay ngang màn hình
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi_VN', null); // Khởi tạo ngôn ngữ Việt Nam
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,



      // ✅ Thêm các dòng sau:
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate, // ✅ cần thiết!
      ],
      supportedLocales: const [
        Locale('en'), // hoặc thêm Locale('vi') nếu bạn dùng tiếng Việt
        Locale('vi'),
      ],




      title: 'Flutter Demo',
      theme: ThemeData(
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Jost',







      ),
      home: SplashScreens(),
      // home: SplashWidget(),
      // home: SplashNextScreenWidget(screenWidget: LoginScreen()),
      // home: FutureBuilder(future: _checkTokenAndUser(ref), builder: (context, snapshot) {
      //   if(snapshot.connectionState == ConnectionState.waiting){
      //     return Center(child: CircularProgressIndicator(),);
      //   }
      //   final user = ref.watch(userProvider);
      //   // return user!= null ? LeaveScreenTemp() :LeaveScreenTemp();
      //   return user!= null ? MainScreen() :LoginScreen();
      //   // return user!= null ? SplashScreens() :LoginScreen();
      //   // return user!= null ? AdminRegisterScreen() :AdminRegisterScreen();
      //   // return user!= null ? NavigatorBottomBar() :NavigatorBottomBar();
      //   // return user!= null ? Responsive() :Responsive();
      //   // return user!= null ? LeaveTypeDropdown() :LeaveTypeDropdown();
      // },),
    );
  }
}
