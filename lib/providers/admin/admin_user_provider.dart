import 'package:daily_manage_user_app/controller/admin/admin_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user.dart';
class AdminUserProvider extends StateNotifier<AsyncValue<List<User>>>{
  AdminUserProvider() : super(const AsyncValue.loading());

  Future<void> fetUsers()async{
    try{
      final users = await AdminUserController().loadUsers();
      state = AsyncValue.data(users);
    } catch (e) {
      print("Error loading users list: $e");
    }
  }


}
final adminUserProvider = StateNotifierProvider<AdminUserProvider, AsyncValue<List<User>>>(
      (ref) => AdminUserProvider(),
);
