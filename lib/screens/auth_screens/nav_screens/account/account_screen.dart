import 'package:daily_manage_user_app/controller/auth_controller.dart';
import 'package:daily_manage_user_app/helpers/tools_colors.dart';
import 'package:daily_manage_user_app/providers/user_provider.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/account/sub_menu/infomation/information_screen.dart';
import 'package:daily_manage_user_app/widgets/dialog_confirm_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

class AccountScreen extends ConsumerStatefulWidget {

  AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.white,
    //   statusBarIconBrightness: Brightness.dark,
    // ));
    final user = ref.watch(userProvider);
    print('user-image - ${user!.image}');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/bg_avatar.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 150, left: 40),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: ClipOval(
                    child: Image(
                      // image: user?.image == null || user!.image.isEmpty
                      //     ? AssetImage(
                      //   user?.sex == 'Male'
                      //       ? 'assets/images/avatar_boy_default.jpg'
                      //       : user?.sex == "Female"
                      //   ? 'assets/images/avatar_girl_default.jpg'
                      //   : 'assets/images/avt_default_2.jpg',
                      // ) as ImageProvider
                      //     : NetworkImage(user.image),
                      image: user?.image == null || user!.image.isEmpty
                          ? AssetImage(
                        user?.sex == 'Male'
                            ? 'assets/images/avatar_boy_default.jpg'
                            : user?.sex == "Female"
                            ? 'assets/images/avatar_girl_default.jpg'
                            : 'assets/images/avt_default_2.jpg',
                      ) as ImageProvider
                          :NetworkImage(user.image), // Sử dụng NetworkImage cho URLs


                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),


              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Row(
                        children: [
                          Text(
                            (user?.fullName == null || user!.fullName.trim().isEmpty)
                                ? 'New User'
                                : user.fullName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // SizedBox(width: 60),
                          // Text(
                          //   '18',
                          //   style: TextStyle(
                          //     color: Colors.blue,
                          //     fontSize: 20,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          // Icon(Icons.male, color: Colors.blue),
                        ],
                      ),
                      Text(
                        user!.email,
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],),
                  ),

                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      // color: Colors.blue.withOpacity(0.2),
                      // border: Border.all(color: HelpersColors.itemTextField.withOpacity(0.4), width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return InformationScreen();
                              },));
                            }
                            ,child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF328BFF).withOpacity(0.2),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Icon(
                                        CupertinoIcons.person_crop_circle,
                                        color: HelpersColors.itemPrimary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Information',
                                    style: TextStyle(
                                      color: HelpersColors.itemPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right,
                                    color: HelpersColors.itemPrimary,
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: Color(0xFF328BFF).withOpacity(0.2),
                          //     borderRadius: BorderRadius.all(Radius.circular(10)),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Padding(
                          //         padding: const EdgeInsets.all(10.0),
                          //         child: Container(
                          //           width: 40,
                          //           height: 40,
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.all(
                          //               Radius.circular(10),
                          //             ),
                          //           ),
                          //           child: Icon(
                          //             Icons.calendar_month,
                          //             color: HelpersColors.itemPrimary,
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(width: 10),
                          //       Text(
                          //         'Work schedule',
                          //         style: TextStyle(
                          //             color: HelpersColors.itemPrimary,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 16
                          //         ),
                          //       ),
                          //       Spacer(),
                          //       Icon(
                          //         Icons.chevron_right,
                          //         color: HelpersColors.itemPrimary,
                          //       ),
                          //       SizedBox(width: 10),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(height: 10,),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: Color(0xFF328BFF).withOpacity(0.2),
                          //     borderRadius: BorderRadius.all(Radius.circular(10)),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Padding(
                          //         padding: const EdgeInsets.all(10.0),
                          //         child: Container(
                          //           width: 40,
                          //           height: 40,
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.all(
                          //               Radius.circular(10),
                          //             ),
                          //           ),
                          //           child: Icon(
                          //             Icons.calendar_today,
                          //             color: HelpersColors.itemPrimary,
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(width: 10),
                          //       Text(
                          //         'Work history',
                          //         style: TextStyle(
                          //             color: HelpersColors.itemPrimary,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 16
                          //         ),
                          //       ),
                          //       Spacer(),
                          //       Icon(
                          //         Icons.chevron_right,
                          //         color: HelpersColors.itemPrimary,
                          //       ),
                          //       SizedBox(width: 10),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(height: 10,),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: Color(0xFF328BFF).withOpacity(0.2),
                          //     borderRadius: BorderRadius.all(Radius.circular(10)),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Padding(
                          //         padding: const EdgeInsets.all(10.0),
                          //         child: Container(
                          //           width: 40,
                          //           height: 40,
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.all(
                          //               Radius.circular(10),
                          //             ),
                          //           ),
                          //           child: Icon(
                          //             CupertinoIcons.money_dollar_circle,
                          //             color: HelpersColors.itemPrimary,
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(width: 10),
                          //       Text(
                          //         'Salary',
                          //         style: TextStyle(
                          //             color: HelpersColors.itemPrimary,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 16
                          //         ),
                          //       ),
                          //       Spacer(),
                          //       Icon(
                          //         Icons.chevron_right,
                          //         color: HelpersColors.itemPrimary,
                          //       ),
                          //       SizedBox(width: 10),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(height: 10,),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: Color(0xFF328BFF).withOpacity(0.2),
                          //     borderRadius: BorderRadius.all(Radius.circular(10)),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Padding(
                          //         padding: const EdgeInsets.all(10.0),
                          //         child: Container(
                          //           width: 40,
                          //           height: 40,
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.all(
                          //               Radius.circular(10),
                          //             ),
                          //           ),
                          //           child: Icon(
                          //             Icons.settings,
                          //             color: HelpersColors.itemPrimary,
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(width: 10),
                          //       Text(
                          //         'Setting',
                          //         style: TextStyle(
                          //             color: HelpersColors.itemPrimary,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 16
                          //         ),
                          //       ),
                          //       Spacer(),
                          //       Icon(
                          //         Icons.chevron_right,
                          //         color: HelpersColors.itemPrimary,
                          //       ),
                          //       SizedBox(width: 10),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(height: 10,),
                          InkWell(
                            onTap: () {
                              _authController.logoutUser(context);
                            },


                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF328BFF).withOpacity(0.2),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.login,
                                        color: HelpersColors.itemPrimary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Logout',
                                    style: TextStyle(
                                        color: HelpersColors.itemPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right,
                                    color: HelpersColors.itemPrimary,
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
