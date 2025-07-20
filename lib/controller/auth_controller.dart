  import 'dart:convert';
  import 'dart:io';

  import 'package:cloudinary_public/cloudinary_public.dart';
  import 'package:daily_manage_user_app/providers/user_provider.dart';
import 'package:daily_manage_user_app/screens/admin_main_screen.dart';
  import 'package:daily_manage_user_app/screens/common_screens/widgets/splash_next_screen_widget.dart';
  import 'package:daily_manage_user_app/screens/common_screens/widgets/top_notification_widget.dart';
  import 'package:daily_manage_user_app/screens/main_screen.dart';
  import 'package:daily_manage_user_app/services/manage_http_response.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import '../global_variables.dart';
  import '../models/user.dart';
  import '../screens/guest_screens/screens/login_screen.dart';
  import '../widgets/dialog_confirm_widget.dart';

  final providerContainer = ProviderContainer();

  class AuthController {
    // API request register
    Future<void> registerUser({
      required BuildContext context,
      required String email,
      required String password,
    }) async {
      try {
        User user = User(
          id: '',
          role: '',
          fullName: '',
          birthDay: null,
          sex: '',
          email: email,
          password: password,
          image: '',
          phoneNumber: '',
          token: '',
        );
        http.Response response = await http.post(
          Uri.parse('$uri/api/register'),
          body: user.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          },
        );
        print('response - ${response.body.toString()}');
        manageHttpResponse(response, context, () {
          showSnackBar(context, 'Account has been created for you');
        });
      } catch (e) {
        print('Error request-response auth register: $e');
      }
    }

    // API request login
    Future<void> loginUser(BuildContext context,
        WidgetRef ref,
        String email,
        String password,) async {
      try {
        http.Response response = await http.post(
          Uri.parse('$uri/api/login'),
          body: jsonEncode({'email': email, 'password': password}),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          },
        );
        print('response - ${response.body.toString()}');
        manageHttpResponse(response, context, () async {
          // Save data local
          SharedPreferences preferences = await SharedPreferences.getInstance();
          // save token user from backend
          String token = jsonDecode(response.body)['token'];
          await preferences.setString('auth_token', token);
          final userJson = jsonEncode(jsonDecode(response.body)['user']);
          //comment thay bằng dưới
          // providerContainer.read(userProvider.notifier).setUser(userJson);
          ref.read(userProvider.notifier).setUser(userJson);
          await preferences.setString('user', userJson);

          String rulePerson = jsonDecode(userJson)['role'];

          if(rulePerson == 'admin'){
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SplashNextScreenWidget(screenWidget: AdminMainScreen());
                  // return MainScreen();
                },
              ),
                  (route) => false,
            );
          }else{
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SplashNextScreenWidget(screenWidget: MainScreen());
                  // return MainScreen();
                },
              ),
                  (route) => false,
            );
          }
          // showSnackBar(context, 'Accout has been login success');
          showTopNotification(
            context: context,
            message: 'Login success',
            type: NotificationType.success,
          );
        });
      } catch (e) {
        print('Error request-response auth register: $e');
      }
    }

    Future<void> logoutUser(context) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('auth_token');
      await preferences.remove('user');
      providerContainer.read(userProvider.notifier).signOut();

      showDialog(
        context: context,
        builder: (context) {
          return DialogConfirmWidget(
            title: 'Logout',
            content: 'Are you sure want to log out of your account !',
            onConfirm: () {
              Navigator.of(context).pop(); // Đóng Dialog
              // Đợi một khung hình rồi mới chuyển trang để tránh xung đột context
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.pushAndRemoveUntil(
                  context,
                  // MaterialPageRoute(builder: (context) => LoginScreen()),
                  MaterialPageRoute(
                    builder: (context) =>
                        SplashNextScreenWidget(screenWidget: LoginScreen()),
                  ),
                      (route) => false,
                );
              });
              showTopNotification(
                context: context,
                message: 'Logout success',
                type: NotificationType.success,
              );
            },
          );
        },
      );

      // showSnackBar(context, 'Logout success');
    }

    Future<bool> updateInformationUser({
      required String id,
      required String? fullName,
      required DateTime? birthDay,
      required String? sex,
      required File? image,
      required String? phoneNumber,
    }) async {
      final String imageStr;
      try {
        Map<String, dynamic> updateFields = {};
        if (fullName != null) {
          updateFields['fullName'] = fullName;
        }
        if (birthDay != null) {
          updateFields['birthDay'] = birthDay.toIso8601String();
        }
        if (sex != null) {
          updateFields['sex'] = sex;
        }
        if (image != null) {
          final cloudinary = CloudinaryPublic('doiar6ybd', 'daily_manage');
          CloudinaryResponse imageResponse = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(image.path, folder: image.path.toString()),
          );
          imageStr = imageResponse.secureUrl;
          updateFields['image'] = imageStr;
        }
        if (phoneNumber != null) {
          updateFields['phoneNumber'] = phoneNumber;
        }
        http.Response response = await http.put(
          Uri.parse('$uri/api/user/$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(updateFields),
        );

        print('✅ PUT response: ${response.statusCode} - ${response.body}');



        if (response.statusCode == 200) {
          // Cập nhật userProvider với dữ liệu từ server
          final updatedUser = User.fromJson(response.body);
          providerContainer.read(userProvider.notifier).updateUser(updatedUser);

          // Cập nhật SharedPreferences
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setString('user', response.body);

          return true;
        }

        return response.statusCode == 200;
      } catch (e) {
        print('❌ Exception updateWorkByUser: $e');
        return false;
      }
    }

    // method forgot password
    Future<bool> completeForgotPassword({required String email}) async {
      try {
        http.Response response = await http.post(
          Uri.parse('$uri/api/user/request-otp'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({'email': email}),
        );
        return response.statusCode == 200 || response.statusCode == 201;
      } catch (e) {
        print('❌ Exception forgot password: $e');
        return false;
      }
    }
    // method forgot password
    Future<bool> completeVerityOTP({required String email,required String otp}) async {
      try {
        http.Response response = await http.post(
          Uri.parse('$uri/api/user/verify-otp'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({'email': email,
                            'otp': otp}),
        );
        return response.statusCode == 200 || response.statusCode == 201;
      } catch (e) {
        print('❌ Exception forgot password: $e');
        return false;
      }
    }
    // method forgot password
    Future<bool> completeRecoverPassword({required String email,required String otp, required String newPassword}) async {
      try {
        http.Response response = await http.post(
          Uri.parse('$uri/api/user/reset-password'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({'email': email,
            'otp': otp,
          'newPassword' : newPassword
          }),
        );
        return response.statusCode == 200 || response.statusCode == 201;
      } catch (e) {
        print('❌ Exception recover password: $e');
        return false;
      }
    }
  }
