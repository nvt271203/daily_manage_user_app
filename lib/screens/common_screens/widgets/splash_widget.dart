import 'package:daily_manage_user_app/screens/common_screens/widgets/top_notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import '../../../helpers/tools_colors.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   showTopNotification(
    //     context: context,
    //     message: 'Kết nối thành công!',
    //     type: NotificationType.success,
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    // Đặt màu thanh trạng thái trùng với màu nền splash
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: HelpersColors.primaryColor, // 🔹 Màu nền
        statusBarIconBrightness:
            Brightness.light, // 🔹 Trạng thái icon (sáng/tối)
      ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: HelpersColors.primaryColor,
        body: Center(
          child:

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TopNotificationWidget(
              //   message: 'This is message',
              //   type: NotificationType.success,
              //   onDismissed: () {},
              // ),
              Lottie.asset('assets/lotties/splash_primary.json', width: 300),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.book_outlined,
                      // hoặc Icons.work, Icons.check_circle
                      color: HelpersColors.primaryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Daily Manage',
                    style: GoogleFonts.oswald(
                      textStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              // Text('Daily Manage',
              //   style: GoogleFonts.oswald(
              //     textStyle: TextStyle(
              //       fontSize: 28,
              //       fontWeight: FontWeight.w900,
              //       // color: HelpersColors.primaryColor,
              //       color: Colors.white,
              //       letterSpacing: 2,
              //     ),
              //   ),
              // ),

              // const Text(
              //   "Daily Manage",
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 28,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 1.2,
              //   ),
              // ),
              const SizedBox(height: 40),
              Text(
                textAlign: TextAlign.center,
                "Effective daily work management \n application",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
