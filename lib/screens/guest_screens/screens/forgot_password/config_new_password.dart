import 'package:daily_manage_user_app/controller/auth_controller.dart';
import 'package:daily_manage_user_app/screens/common_screens/widgets/top_notification_widget.dart';
import 'package:daily_manage_user_app/screens/guest_screens/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../../../../helpers/tools_colors.dart';
import '../../../../models/user.dart';

class ConfigNewPassword extends StatefulWidget {
  const ConfigNewPassword({super.key, required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  State<ConfigNewPassword> createState() => _ConfigNewPasswordState();
}

class _ConfigNewPasswordState extends State<ConfigNewPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _passwordFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _confirmPasswordFieldKey =
      GlobalKey<FormFieldState>();

  String _password = '';
  String _confirmPassword = '';

  // Check file có đang được nhấn hay không
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmPasswordFocusNode;

  // display, hide password
  bool _obscurePassword = true;
  bool _showTogglePasswordIcon = false;

  bool _obscureConfirmPassword = true;
  bool _showToggleConfirmPasswordIcon = false;

  User user = User.newUser();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    // Lắng nghe sự kiện pass có đc nhấn ko
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        _passwordFieldKey.currentState?.validate();
      }
    });
    _confirmPasswordFocusNode.addListener(() {
      if (!_confirmPasswordFocusNode.hasFocus) {
        _confirmPasswordFieldKey.currentState?.validate();
      }
    });
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

  void _recoveryPassword() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final completeRecoverPassword = await AuthController()
          .completeRecoverPassword(
            email: widget.email,
            otp: widget.otp,
            newPassword: _password,
          );
      if (completeRecoverPassword) {
        showTopNotification(
          context: context,
          message: 'Recover Password Successfully',
          type: NotificationType.success,
        );
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
          return LoginScreen();
        },), (route) {
          return false;
        },);
      }else{
        showTopNotification(
          context: context,
          message: 'OTP is invalid or expired',
          type: NotificationType.error,
        );
      }
    }
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
            'Create New Password',
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Lottie.asset(
                    'assets/lotties/new_password.json',
                    width: 200,
                    height: 250,
                  ),
                ),
                Center(
                  child: Text(
                    'Set New Password',
                    style: TextStyle(
                      color: HelpersColors.itemPrimary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.6),
                          letterSpacing: 0.4,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'In order to keep your account safe you need to create a strong password',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextFile('Password'),
                      TextFormField(
                        initialValue: _password,
                        key: _passwordFieldKey,
                        focusNode: _passwordFocusNode,
                        onChanged: (value) {
                          _password = value;
                          setState(() {
                            _showTogglePasswordIcon = value.trim().length >= 1;
                          });
                        },
                        validator: (value) {
                          return user.passwordValidate(value);
                        },
                        obscureText: _obscurePassword,
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
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            color: HelpersColors.itemTextField.withOpacity(0.8),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: HelpersColors.itemTextField,
                          ),
                          suffixIcon: _showTogglePasswordIcon
                              ? IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: HelpersColors.itemTextField,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                )
                              : null,
                        ),
                      ),
                      _buildTextFile('Confirm Password'),
                      TextFormField(
                        initialValue: _confirmPassword,
                        key: _confirmPasswordFieldKey,
                        focusNode: _confirmPasswordFocusNode,
                        onChanged: (value) {
                          _confirmPassword = value;
                          setState(() {
                            _showToggleConfirmPasswordIcon =
                                value.trim().length >= 1;
                          });
                        },
                        validator: (value) {
                          return user.confirmPasswordValidateMatch(
                            value,
                            _password,
                          );
                        },
                        obscureText: _obscureConfirmPassword,
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
                          hintText: 'Enter your confirm password',
                          hintStyle: TextStyle(
                            color: HelpersColors.itemTextField.withOpacity(0.8),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: HelpersColors.itemTextField,
                          ),
                          suffixIcon: _showToggleConfirmPasswordIcon
                              ? IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: HelpersColors.itemTextField,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                InkWell(
                  onTap: () => _isLoading ? null : _recoveryPassword(),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: HelpersColors.itemPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 50),
                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : Text(
                                'Recover Password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                        Spacer(),
                        Icon(
                          Icons.arrow_right_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(width: 20),
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
