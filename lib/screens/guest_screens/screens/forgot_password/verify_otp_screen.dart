import 'dart:async';

import 'package:daily_manage_user_app/screens/common_screens/widgets/top_notification_widget.dart';
import 'package:daily_manage_user_app/screens/guest_screens/screens/forgot_password/config_new_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../controller/auth_controller.dart';
import '../../../../helpers/tools_colors.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenScreenState();
}

class _VerifyOtpScreenScreenState extends State<VerifyOtpScreen> {
  bool _isSending = false;
  int _start = 30;
  Timer? _timer;
  String _otpCode = '';

  void startTimer() {
    _start = 30;
    _timer?.cancel(); // Hủy nếu đang chạy trước đó
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _sendVerifyOTP() async {
    if (_otpCode.isEmpty) {
      showTopNotification(
        context: context,
        message: '4-digit OTP code cannot be blank',
        type: NotificationType.error,
      );
      return;
    }
    if (_otpCode.length < 4) {
      showTopNotification(
        context: context,
        message: 'must enter full 4 digit OTP code',
        type: NotificationType.error,
      );
      return;
    }
    final isStatusRequestVerityOTP = await AuthController().completeVerityOTP(
      email: widget.email,
      otp: _otpCode,
    );
    if (isStatusRequestVerityOTP) {
      showTopNotification(
        context: context,
        message: '4-digit OTP code authentication successful',
        type: NotificationType.success,
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ConfigNewPassword(email: widget.email, otp: _otpCode);
          },
        ),
      );
    } else {
      showTopNotification(
        context: context,
        message: 'OTP is invalid or expired',
        type: NotificationType.error,
      );
    }

    // if (_formKey.currentState!.validate()) {
    //   setState(() => _isSending = true);
    //   // // TODO: Call NodeJS API to send reset email here
    //   // await Future.delayed(const Duration(seconds: 2)); // simulate loading
    //   final isStatusRequestForgotPassword = await AuthController()
    //       .completeForgotPassword(email: _email);
    //   if (isStatusRequestForgotPassword) {
    //     showTopNotification(
    //       context: context,
    //       message: 'OTP code sent to email',
    //       type: NotificationType.success,
    //     );
    //     Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (context) {
    //           return OtpSentScreen(email: _email);
    //         },
    //       ),
    //     );
    //   } else {
    //     showTopNotification(
    //       context: context,
    //       message: 'Email not found',
    //       type: NotificationType.error,
    //     );
    //   }
    //
    //   setState(() => _isSending = false);
    //
    //   // if (mounted) {
    //   //   ScaffoldMessenger.of(context).showSnackBar(
    //   //     SnackBar(content: Text('A reset password link has been sent to $email')),
    //   //   );
    //   // }
    // }
  }

  void _resendAgainOtpCode() async {
    final completeResendAgainOtp = await AuthController().completeForgotPassword(email: widget.email);
    if(completeResendAgainOtp){
      showTopNotification(
        context: context,
        message: 'OTP reissue request sent to email',
        type: NotificationType.success,
      );
    }else{
      showTopNotification(
        context: context,
        message: 'Error occurred while sending otp to email',
        type: NotificationType.error,
      );
    }


    startTimer();
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
            'Verify OTP',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: HelpersColors.itemPrimary,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                Lottie.asset(
                  'assets/lotties/otp_enter.json',
                  width: 200,
                  height: 250,
                ),
                Center(
                  child: Text(
                    'Get Your Code',
                    style: TextStyle(
                      color: HelpersColors.itemPrimary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        letterSpacing: 0.4,
                      ),
                      children: [
                        TextSpan(
                          text:
                              'Please enter the 4 digit code that \nsend to email ',
                        ),
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(
                            color: Colors.blue, // 🔵 Màu riêng cho email
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: 260,
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    // controller: _otpController,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,

                    textStyle: const TextStyle(
                      color: Colors.white, // 👈 Màu chữ trắng
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 60,
                      fieldWidth: 50,

                      // Màu nền của ô đã được nhập
                      activeFillColor: HelpersColors.itemPrimary,
                      // Màu viền của ô đã được nhập
                      activeColor: HelpersColors.itemPrimary,

                      // Màu nền ô input đc nhập.
                      selectedFillColor: Colors.white,
                      // Màu Viền của ô đang được chọn
                      selectedColor: HelpersColors.primaryColor,

                      // Viền của các ô chưa được chọn
                      inactiveColor: HelpersColors.itemPrimary,
                      // nền của các ô chưa được chọn
                      inactiveFillColor: HelpersColors.bgFillTextField,
                    ),
                    enableActiveFill: true,
                    onChanged: (value) {
                      setState(() {
                        _otpCode = value;
                      });
                    },
                    onCompleted: (value) {
                      setState(() {
                        _otpCode = value;
                      });
                      print("OTP nhập xong: $value");
                    },
                  ),
                ),

                Center(
                  child: Text(
                    'Did\'t receive OTP ?',
                    textAlign: TextAlign.center, // 👈 căn giữa nội dung chữ
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        _start == 0 && !_isSending ? _resendAgainOtpCode() : null;
                      },
                      child: Text(
                        'Resend again ',
                        style: TextStyle(
                          color: _start == 0 && !_isSending
                              ? HelpersColors.itemPrimary
                              : Colors.black26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_start > 0)
                      Row(
                        children: [
                          Text('after '),
                          Text(
                            '$_start s',
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSending ? null : _sendVerifyOTP,
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
                              SizedBox(width: 80),
                              const Text(
                                'Verify OTP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_right_alt,
                                size: 25,
                                color: Colors.white,
                              ),
                              SizedBox(width: 80),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
