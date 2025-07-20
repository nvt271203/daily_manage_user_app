import 'package:daily_manage_user_app/controller/auth_controller.dart';
import 'package:daily_manage_user_app/helpers/tools_colors.dart';
import 'package:daily_manage_user_app/screens/common_screens/widgets/top_notification_widget.dart';
import 'package:daily_manage_user_app/screens/guest_screens/screens/forgot_password/verify_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../../../../models/user.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormFieldState> _emailFieldKey = GlobalKey<FormFieldState>();

  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;
  bool _isSended = false;
  late FocusNode _emailFocusNode;

  String _email = '';
  User user = User.newUser();

  void _sendResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSending = true);
      // // TODO: Call NodeJS API to send reset email here
      // await Future.delayed(const Duration(seconds: 2)); // simulate loading
      final isStatusRequestForgotPassword = await AuthController()
          .completeForgotPassword(email: _email);
      if (isStatusRequestForgotPassword) {
        showTopNotification(
          context: context,
          message: 'OTP code sent to email',
          type: NotificationType.success,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return VerifyOtpScreen(email: _email);
            },
          ),
        );
      } else {
        showTopNotification(
          context: context,
          message: 'Email not found',
          type: NotificationType.error,
        );
      }

      setState(() => _isSending = false);

      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('A reset password link has been sent to $email')),
      //   );
      // }
    }
  }

  Widget _buildTextFile(String title) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, bottom: 5),
      child: Text(
        title,
        style: TextStyle(
          color: HelpersColors.itemPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailFocusNode = FocusNode();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        _emailFieldKey.currentState?.validate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: HelpersColors.itemPrimary,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Forgot Password',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: HelpersColors.itemPrimary,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Lottie.asset(
                    'assets/lotties/sent_email.json',
                    width: 300,
                    height: 250,
                  ),
                  Center(
                    child: Text(
                      'Mail Address Here',
                      style: TextStyle(
                        color: HelpersColors.itemPrimary,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  Center(
                    child: const Text(
                      'Please enter your email \nTo receive a OTP reset password',
                      textAlign: TextAlign.center, // 👈 căn giữa nội dung chữ
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextFile('Email'),
                  TextFormField(
                    initialValue: _email,
                    key: _emailFieldKey,
                    focusNode: _emailFocusNode,
                    // 👈 Thêm dòng này
                    onChanged: (value) {
                      _email = value;
                    },
                    validator: (value) {
                      return user.emailValidate(value);
                    },
                    style: TextStyle(color: Colors.blue),
                    // 👈 Màu chữ khi gõ vào (focus)sss
                    decoration: InputDecoration(
                      fillColor: HelpersColors.bgFillTextField,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: HelpersColors.bgFillTextField,
                          width: 1.0,
                        ),
                      ),
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(
                        color: HelpersColors.itemTextField.withOpacity(0.8),
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: HelpersColors.itemTextField,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSending ? null : _sendResetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HelpersColors.itemPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isSending
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                          : Row(
                              children: [
                                SizedBox(width: 80,),
                                const Text(
                                  'Send Reset Code',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_right_alt,size: 25,color: Colors.white,),
                                SizedBox(width: 80,),
                              ],
                            ),
                    ),
                  ),

                  // if (_isSended) ...[
                  //   const SizedBox(height: 20),
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 100),
                  //     child: Container(height: 1, color: HelpersColors.itemPrimary),
                  //   ),
                  // const SizedBox(height: 10),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       'Password reset link sent successfully',
                  //       style: TextStyle(
                  //         color: HelpersColors.itemPrimary,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 10),
                  //     Icon(Icons.check_circle, color: HelpersColors.itemPrimary),
                  //   ],
                  // ),
                  // const SizedBox(height: 10),
                  // const Text('Once you have set a new password'),
                  // const Text('Please go back and log in with your new password.'),
                  // const SizedBox(height: 20),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  //     decoration: BoxDecoration(
                  //       color: HelpersColors.bgFillTextField,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Text(
                  //           'Login with new password',
                  //           style: TextStyle(
                  //             color: HelpersColors.itemPrimary,
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 16,
                  //           ),
                  //         ),
                  //         const SizedBox(width: 20),
                  //         Icon(Icons.arrow_right_alt, color: HelpersColors.primaryColor),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
