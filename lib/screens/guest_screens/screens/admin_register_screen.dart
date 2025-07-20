import 'package:daily_manage_user_app/controller/auth_controller.dart';
import 'package:daily_manage_user_app/helpers/format_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../helpers/tools_colors.dart';
import '../../../models/user.dart';

class AdminRegisterScreen extends StatefulWidget {
  const AdminRegisterScreen({super.key});

  @override
  State<AdminRegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<AdminRegisterScreen> {
  AuthController _authController = AuthController();
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User user = User.newUser();

  //--------
  late String _email;
  late String _password;

  Future<void> _register() async {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate()) {
      print(_email);
      print(_password);
      setState(() {
        _isLoading = true;
      });
      await _authController.registerUser(
        context: context,
        email: _email,
        password: _password,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTextFile(String title) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, bottom: 5),
      child: Text(
        title,
        style: TextStyle(
          color: HelpersColors.itemPrimary_admin,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: HelpersColors.itemPrimary_admin,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => _register(),
            icon: Icon(Icons.save, color: Colors.white),
          ),
        ],
        title: Center(
          child: Text(
            'Register Account',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/bg_1.png',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Center(
                      child: Text(
                        'Admin Daily Manage',
                        style: TextStyle(
                          color: HelpersColors.itemPrimary_admin,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Provision an account for a user',
                              style: TextStyle(
                                color: Colors.blueGrey.shade800,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Icon(
                              Icons.person_add_alt_1_rounded,
                              color: Colors.blueGrey.shade700,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    _buildTextFile('Email'),
                    TextFormField(
                      onChanged: (value) {
                        _email = value;
                      },
                      validator: (value) {
                        return user.emailValidate(value);
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: HelpersColors.itemTextField),
                      decoration: InputDecoration(
                        fillColor: HelpersColors.bgFillTextField,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: HelpersColors.itemPrimary_admin,
                          ),
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
                          color: HelpersColors.itemPrimary_admin.withOpacity(
                            0.5,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: HelpersColors.itemPrimary_admin,
                        ),
                      ),
                    ),
                    _buildTextFile('Password'),
                    TextFormField(
                      obscureText: true,
                      onChanged: (value) {
                        _password = value;
                      },
                      validator: (value) {
                        return user.passwordValidate(value);
                      },
                      style: TextStyle(color: HelpersColors.itemTextField),
                      decoration: InputDecoration(
                        fillColor: HelpersColors.bgFillTextField,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: HelpersColors.itemPrimary_admin,
                          ),
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
                          color: HelpersColors.itemPrimary_admin.withOpacity(
                            0.5,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: HelpersColors.itemPrimary_admin,
                        ),
                      ),
                    ),

                    SizedBox(height: 25),
                    InkWell(
                      onTap: () {
                        _isLoading ? null : _register();
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: HelpersColors.itemPrimary_admin,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          children: [
                            Spacer(),
                            _isLoading
                                ? Center(child: CircularProgressIndicator())
                                : Text(
                                    'Save new account',
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(child: Text('Tính năng hiện đang bảo trì')),
                                behavior: SnackBarBehavior.floating,
                                // làm nổi phía trên bottom bar
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text(
                            'Import accounts from file exel',
                            style: TextStyle(
                              color: HelpersColors.itemPrimary_admin,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Login now !',
                            style: TextStyle(
                              color: HelpersColors.itemPrimary_admin,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
