import 'package:daily_manage_user_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../helpers/tools_colors.dart'; // nhớ import nếu chưa có

class HeaderHomeWidget extends ConsumerWidget {
  const HeaderHomeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Màu bạn muốn
        statusBarIconBrightness: Brightness.dark, // Icon màu trắng
      ),
    );

    final user = ref.watch(userProvider);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1652FF), Color(0xFFAB64FF)],
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(50)),
              child: user?.image == null || user!.image.isEmpty
                  ? Image.asset(
                      user?.sex == 'Male'
                          ? 'assets/images/avatar_boy_default.jpg'
                          : user?.sex == 'Female'
                          ? 'assets/images/avatar_girl_default.jpg'
                          : 'assets/images/avt_default_2.jpg',
                      width: 60,
                      height: 60,
                    )
                  : Image.network(user.image, width: 50, height: 50, fit:BoxFit.cover),
            ),
          ),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style: GoogleFonts.oswald(
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
              Text(
                (user?.fullName == null || user!.fullName.trim().isEmpty) ?
                'New user'
                    :
                user.fullName,
                style: GoogleFonts.oswald(
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    // color: HelpersColors.primaryColor,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'A fresh start, a new chance!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontStyle: FontStyle.italic
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(40))
              ),
              child: Icon(Icons.notifications_active,color: HelpersColors.primaryColor,))
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.logout, color: Colors.white),
          // ),
        ],
      ),
    );
  }
}
