import 'dart:convert';

const sex = ['Female', 'Male'];

class User {
  final String id;
  final String role;
  final String fullName;
  final DateTime? birthDay;
  final String? sex;
  final String email;
  final String password;
  final String image;
  final String phoneNumber;
  final String token;

  User copyWith({
    String? id,
    String? role,
    String? fullName,
    DateTime? birthDay,
    String? sex,
    String? email,
    String? password,
    String? image,
    String? phoneNumber,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      birthDay: birthDay ?? this.birthDay,
      sex: sex ?? this.sex,
      email: email ?? this.email,
      password: password ?? this.password,
      image: image ?? this.image,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      token: token ?? this.token,
    );
  }




  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "role": this.role,
      "fullName": this.fullName,
      "birthDay": birthDay != null ? birthDay!.toIso8601String() : null,
      "sex": this.sex,
      "email": this.email,
      "password": this.password,
      "image": this.image,
      "phoneNumber": this.phoneNumber,
    };
  }

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json["_id"] ?? "",
      role: json["role"] ?? "",
      fullName: json["fullName"] ?? "",
      birthDay: json["birthDay"] != null ? DateTime.parse(json["birthDay"]) : null,
      sex: json["sex"] ?? null,
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      image: json["image"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      token: '',
    );
  }

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  factory User.newUser() {
    return User(
      id: '',
      role: '',
      fullName: '',
      birthDay: null,
      sex: '',
      email: '',
      password: '',
      image: '',
      phoneNumber: '',
      token: '',
    );
  }

  User({
    required this.id,
    required this.role,
    required this.fullName,
    required this.birthDay,
    required this.sex,
    required this.email,
    required this.password,
    required this.image,
    required this.phoneNumber,
    required this.token,
  });

  String? fullNameValidate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '"Full name" is not empty !';
    }
    return null;
  }
  String? phoneNumberValidate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '"Full name" is not empty !';
    }
    // Kiểm tra nếu có ký tự không phải là số
    final isNumeric = RegExp(r'^\d+$');
    if (!isNumeric.hasMatch(value.trim())) {
      return '"Phone number" is not string type !';
    }
    if(value.length < 9 || value.length > 12){
      return '"Phone Number" must be 9 to 12 digits long !';
    }
    return null;
  }
  String? birthDayValidate(DateTime? value) {
    if (value == null) {
      return 'Please choose birthday';
    }
    return null;
  }

  String? sexValidate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please choose sex';
    }
    return null;
  }

  String? emailValidate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '"Email" cannot be blank !';
    }
    // Biểu thức chính quy để kiểm tra định dạng email
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (!emailRegex.hasMatch(value.trim())) {
      return '"EMAIL" must be a valid email !';
    }
    return null;
  }

  String? passwordValidate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '"Password" cannot be blank !';
    }
    if (value.trim().length < 8) {
      return '"Password" must be at least 8 characters!';
    }
    return null;
  }

  String? confirmPasswordValidateMatch(String? value, String? originalPassword) {
    if (value == null || value.trim().isEmpty) {
      return '"Confirm Password" cannot be blank!';
    }
    if(originalPassword == null || originalPassword.trim().isEmpty){
      return '"Password" must be entered before confirming!';
    }
    if (value.trim() != originalPassword.trim()) {
      return '"Confirm Password" does not match!';
    }
    return null;
  }
}
