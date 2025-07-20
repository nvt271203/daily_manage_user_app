import 'dart:convert';

import '../../global_variables.dart';
import '../../models/user.dart';
import 'package:http/http.dart' as http;

class AdminUserController {
  Future<List<User>> loadUsers ()async {
    try {
      http.Response response = await http.get(
          Uri.parse('$uri/api/users'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          }
      );
      print('response - ${response.body.toString()}');
      if (response.statusCode == 200) {
        List<dynamic> users = jsonDecode(response.body);
        if (users.isNotEmpty) {
          return users.map((user) => User.fromMap(user)).toList();
        } else {
          print('Users not found');
          return [];
        }
      } else if (response.statusCode == 404) {
        print('Users not found');
        return [];
      } else {
        throw Exception('Failed to load Users');
      }
    } catch (e) {
      print('Error request-response auth loadWorkByUsers: $e');
      return [];
    }
  }
}