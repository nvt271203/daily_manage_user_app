import 'package:daily_manage_user_app/controller/auth_controller.dart';
import 'package:daily_manage_user_app/helpers/tools_colors.dart';
import 'package:daily_manage_user_app/screens/guest_screens/screens/admin_register_screen.dart';
import 'package:daily_manage_user_app/screens/guest_screens/screens/forgot_password/forget_password_screen.dart';
import 'package:daily_manage_user_app/screens/guest_screens/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  AuthController _authController = AuthController();
  bool isLoading = false;

  final GlobalKey<FormFieldState> _emailFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordFieldKey = GlobalKey<FormFieldState>();
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

// display, hide password
  bool _obscurePassword = true;
  bool _showTogglePasswordIcon = false;

  // remember account
  bool _rememberAccount = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User user = User.newUser();
  // late String _email ;
  // late String _password;
  // late String _password;
  String _email = '';
  String _password = '';

  bool _isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        _emailFieldKey.currentState?.validate();
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        _passwordFieldKey.currentState?.validate();
      }
    });
  // mặc định sẽ load dữ liệu account ghi nhớ.
    _loadSavedLogin();
  }
  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
  void _loadSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberAccount = prefs.getBool('rememberMe') ?? false;
      if (_rememberAccount) {
        _email = prefs.getString('email') ?? '';
        _password = prefs.getString('password') ?? '';
      }
      setState(() {
        _isLoaded = true;
      });
    });
  }
  Future<void> _login() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {

      if (_rememberAccount) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('rememberMe', true);
        await prefs.setString('email', _email);
        await prefs.setString('password', _password);
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('rememberMe');
        await prefs.remove('email');
        await prefs.remove('password');
      }

      print(_email);
      print(_password);
      setState(() {
        isLoading = true;
      });
      await _authController.loginUser(context, ref, _email, _password);
      setState(() {
        isLoading = false;
      });
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
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: HelpersColors.itemPrimary,
      statusBarIconBrightness: Brightness.light,
    ));

    if (!_isLoaded) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: HelpersColors.itemPrimary,
          title: Center(
            child: Text(
              'Login account',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/bg_1.png',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Center(
                      child: Text(
                        'App Daily Manage',
                        style: TextStyle(
                          color: HelpersColors.itemPrimary,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Center(
                    //   child: Text(
                    //     'Login',
                    //     style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    SizedBox(height: 15),
                    _buildTextFile('Email'),
                    TextFormField(
                      initialValue: _email,
                      key: _emailFieldKey,
                      focusNode: _emailFocusNode, // 👈 Thêm dòng này
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
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberAccount,
                          onChanged: (value) {
                            setState(() {
                              _rememberAccount = value ?? false;
                            });
                          },
                          activeColor: HelpersColors.itemPrimary, // ✅ Màu của border và tick khi được chọn
                          checkColor: Colors.white,
                        ),
                         Text(
                          'Remember login next time',
                          style: TextStyle(fontWeight: FontWeight.bold, color: HelpersColors.itemPrimary),
                        ),
      
                      ],
                    ),
      
      
      
                    SizedBox(height: 40),
                    InkWell(
                      onTap: () => isLoading ? null : _login(),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: HelpersColors.itemPrimary,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 50),
                            isLoading
                                ? Center(child: CircularProgressIndicator())
                                : Text(
                                    'Login now',
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
                    SizedBox(height: 10),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return ForgetPasswordScreen();
                            },));
                          },
                          child: Text(
                            'Forgot password ?',
                            style: TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Spacer(),
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) {
                        //           // return RegisterScreen();
                        //           return AdminRegisterScreen();
                        //         },
                        //       ),
                        //     );
                        //   },
                        //   child: Text(
                        //     'Register now !',
                        //     style: TextStyle(
                        //       color: HelpersColors.itemPrimary,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
