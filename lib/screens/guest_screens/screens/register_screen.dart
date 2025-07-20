// import 'package:daily_manage_user_app/controller/auth_controller.dart';
// import 'package:daily_manage_user_app/helpers/format_helper.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../helpers/tools_colors.dart';
// import '../../models/user.dart';
//
// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   AuthController _authController = AuthController();
//   bool _isLoading = false;
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   User user = User.newUser();
//
//   //--------
//   late String _fullName;
//   DateTime? _birthDay;
//   String? _sex;
//   late String _email;
//   late String _password;
//
//   bool _errorBirthday = false;
//   bool _errorSex = false;
//
//   void _presentDatePicker() async {
//     final now = DateTime.now();
//     // 👇 Ngày mặc định hiển thị khi mở picker (1/1/2000)
//     final initialDate = DateTime(2000, 1, 1);
//     final firstDay = DateTime(now.year - 100, now.month, now.day);
//     final pickerDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: firstDay,
//       lastDate: now,
//     );
//     setState(() {
//       _birthDay = pickerDate;
//     });
//   }
//
//   Future<void> _register() async {
//     // Check enter birthday
//     if(_birthDay == null){
//       setState(() {
//         _errorBirthday = true;
//         return;
//       });
//     }else{
//       setState(() {
//         _errorBirthday = false;
//       });
//     }
//     // Check enter sex
//     if(_sex == null){
//       setState(() {
//         _errorSex = true;
//         return;
//       });
//     }else{
//       setState(() {
//         _errorSex = false;
//       });
//     }
//     if (_formKey.currentState != null && _formKey.currentState!.validate() && !_errorBirthday && !_errorSex) {
//       print(_fullName);
//       print(_birthDay);
//       print(_sex);
//       print(_email);
//       print(_password);
//       setState(() {
//         _isLoading = true;
//       });
//       await _authController.registerUser(
//         context,
//         _fullName,
//         _birthDay!,
//         _sex!,
//         _email,
//         _password,
//       );
//       setState(() {
//         _isLoading = false;
//       });
//     }
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: HelpersColors.itemPrimary,
//         iconTheme: IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             onPressed: () => _register(),
//             icon: Icon(Icons.save, color: Colors.white),
//           ),
//         ],
//         title: Center(
//           child: Text(
//             'Register Account',
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Image.asset(
//                       'assets/images/bg_1.png',
//                       height: 250,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                     Center(
//                       child: Text(
//                         'App Daily Manage',
//                         style: TextStyle(
//                           color: HelpersColors.itemPrimary,
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       onChanged: (value) {
//                         _fullName = value;
//                       },
//                       validator: (value) {
//                         return user.fullNameValidate(value);
//                       },
//                       style: TextStyle(color: Colors.blue),
//                       // 👈 Màu chữ khi gõ vào (focus)sss
//                       decoration: InputDecoration(
//                         fillColor: HelpersColors.bgFillTextField,
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Colors.blue),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(
//                             color: HelpersColors.bgFillTextField,
//                             width: 1.0,
//                           ),
//                         ),
//                         hintText: 'Enter your fullname',
//                         hintStyle: TextStyle(
//                           color: HelpersColors.itemTextField.withOpacity(0.8),
//                         ),
//                         prefixIcon: Icon(
//                           Icons.text_fields_sharp,
//                           color: HelpersColors.itemTextField,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 15),
//
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 3,
//                           child: InkWell(
//                             onTap: () {
//                               _presentDatePicker();
//                             },
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   padding: EdgeInsets.all(15),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(10),
//                                     ),
//                                     border: _errorBirthday ? Border.all(color: HelpersColors.itemSelected, width: 1) : null,
//                                     color: HelpersColors.bgFillTextField,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         Icons.calendar_month,
//                                         color: HelpersColors.itemTextField,
//                                       ),
//                                       SizedBox(width: 15),
//                                       Text(
//                                         _birthDay == null
//                                             ? 'Birthday'
//                                             : FormatHelper.formatDate_DD_MM_YYYY(_birthDay!),
//                                         style: TextStyle(
//                                           color: HelpersColors.itemTextField,
//                                         ),
//                                       ),
//                                       Spacer(),
//                                       Icon(
//                                         Icons.arrow_drop_down,
//                                         color: HelpersColors.itemTextField,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 if (_errorBirthday)
//                                   Text(
//                                     'Please choose birthday',
//                                     style: TextStyle(color: HelpersColors.itemSelected),
//                                   ),
//
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 15),
//                         Expanded(
//                           flex: 2,
//                           child: Column(
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 20,
//                                   vertical: 3,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: HelpersColors.bgFillTextField,
//                                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                                   border: _errorSex ? Border.all(color: HelpersColors.itemSelected, width: 1) : null,
//
//                                 ),
//                                 child: Center(
//                                   child: DropdownButton(
//                                     underline: SizedBox(),
//                                     style: TextStyle(
//                                       color: HelpersColors.itemTextField,
//                                     ),
//                                     dropdownColor: Colors.white,
//                                     value: _sex,
//                                     hint: Center(
//                                       child: Text(
//                                         'Sex',
//                                         style: TextStyle(
//                                           color: HelpersColors.itemTextField
//                                               .withOpacity(0.8),
//                                         ),
//                                       ),
//                                     ),
//                                     items: sex.map((item) {
//                                       return DropdownMenuItem(
//                                         child: Text(item),
//                                         value: item,
//                                       );
//                                     }).toList(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         _sex = value!;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               ),
//                               if (_errorSex)
//                                 Text(
//                                   'Please choose sex',
//                                   style: TextStyle(color: HelpersColors.itemSelected),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 15),
//                     TextFormField(
//                       onChanged: (value) {
//                         _email = value;
//                       },
//                       validator: (value) {
//                         return user.emailValidate(value);
//                       },
//                       keyboardType: TextInputType.emailAddress,
//                       style: TextStyle(color: HelpersColors.itemTextField),
//                       decoration: InputDecoration(
//                         fillColor: HelpersColors.bgFillTextField,
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Colors.blue),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(
//                             color: HelpersColors.bgFillTextField,
//                             width: 1.0,
//                           ),
//                         ),
//                         hintText: 'Enter your email',
//                         hintStyle: TextStyle(
//                           color: HelpersColors.itemTextField.withOpacity(0.8),
//                         ),
//                         prefixIcon: Icon(
//                           Icons.email,
//                           color: HelpersColors.itemTextField,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 15),
//                     TextFormField(
//                       obscureText: true,
//                       onChanged: (value) {
//                         _password = value;
//                       },
//                       validator: (value) {
//                         return user.passwordValidate(value);
//                       },
//                       style: TextStyle(color: HelpersColors.itemTextField),
//                       decoration: InputDecoration(
//                         fillColor: HelpersColors.bgFillTextField,
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Colors.blue),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(
//                             color: HelpersColors.bgFillTextField,
//                             width: 1.0,
//                           ),
//                         ),
//                         hintText: 'Enter your password',
//                         hintStyle: TextStyle(
//                           color: HelpersColors.itemTextField.withOpacity(0.8),
//                         ),
//                         prefixIcon: Icon(
//                           Icons.lock,
//                           color: HelpersColors.itemTextField,
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(height: 15),
//                     InkWell(
//                       onTap: () {
//                         _isLoading ? null : _register();
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                           color: HelpersColors.itemPrimary,
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                         ),
//                         child: Row(
//                           children: [
//                             Spacer(),
//                             _isLoading
//                                 ? Center(child: CircularProgressIndicator())
//                                 : Text(
//                                     'Register',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                             Spacer(),
//                             Icon(
//                               Icons.arrow_right_alt,
//                               color: Colors.white,
//                               size: 30,
//                             ),
//                             SizedBox(width: 20),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Spacer(),
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Text(
//                             'Login now !',
//                             style: TextStyle(
//                               color: HelpersColors.itemPrimary,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
