import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

class UserProvider extends StateNotifier<User?> {
  UserProvider() : super(null);

  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }
  void updateUser(User updatedUser) {
    state = updatedUser;
  }

  // void createUserUpdate() {
  //   if (this.state != null) {
  //     this.state = User(id: this.state!.id,
  //         role: this.state!.role,
  //         fullName: fullName,
  //         birthDay: birthDay,
  //         sex: sex,
  //         email: email,
  //         password: password,
  //         image: image,
  //         phoneNumber: phoneNumber,
  //         token: token)
  //   }
  // }

  void signOut() {
    state = null;
  }

  User? get user => state;
}

final userProvider = StateNotifierProvider<UserProvider, User?>((ref) =>
    UserProvider(),);