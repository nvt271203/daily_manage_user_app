import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';

import '../../../helpers/tools_colors.dart';

class SplashNextScreenWidget extends StatelessWidget {
  const SplashNextScreenWidget({
    super.key,
    required this.screenWidget,
  });

  final Widget screenWidget;

  @override
  Widget build(BuildContext context) {
    // Đặt màu thanh trạng thái
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: HelpersColors.primaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    });

    return SafeArea(
      child: Scaffold(
        body: AnimatedSplashScreen(
          backgroundColor: HelpersColors.primaryColor,
          nextScreen: screenWidget,
          splashIconSize: 400, // đảm bảo vùng splash đủ lớn
          splash: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lotties/splash_primary.json', width: 250),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 24),
                  Lottie.asset('assets/lotties/loadingg.json', width: 100),
                  Text(
                    "Loading...",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
          splashTransition: SplashTransition.fadeTransition,
          duration: 3000,
        ),
      ),
    );
  }
}
