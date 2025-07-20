import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
class UserProvider extends StateNotifier<User?>{
  UserProvider() : super(null);
  void setUser(String userJson){
    state = User.fromJson(userJson);
  }
  void updateUser(User updatedUser) {
    state = updatedUser;
  }

  void signOut(){
    state = null;
  }
  User? get user => state;
}
final userProvider = StateNotifierProvider<UserProvider, User?>((ref) => UserProvider(),);