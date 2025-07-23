import 'dart:io';

import 'package:daily_manage_user_app/controller/auth_controller.dart';
import 'package:daily_manage_user_app/providers/user_provider.dart';
import 'package:daily_manage_user_app/screens/common_screens/widgets/top_notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import '../../../../../../helpers/format_helper.dart';
import '../../../../../../helpers/tools_colors.dart';
import '../../../../../../models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../services/manage_http_response.dart';

class InformationScreen extends ConsumerStatefulWidget {
  const InformationScreen({super.key});

  @override
  _InformationScreenState createState() => _InformationScreenState();
}

class _InformationScreenState extends ConsumerState<InformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? image;
  String? _selectedSex; // hoặc null nếu chưa chọn
  final List<String> sex = ['Male', 'Female', 'Other'];
  final ImagePicker picker = ImagePicker();

  final GlobalKey<FormFieldState> _fullNameFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _phoneNumberFieldKey =
      GlobalKey<FormFieldState>();

  // Lắng nghe sự kiện click
  late TextEditingController _fullNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _positionController;
  late TextEditingController _passwordController;
  DateTime? _birthDay;

  // Lắng nghe sự kiên focus
  late FocusNode _focusNodeFullName;
  late FocusNode _focusNodePhoneNumber;
  bool _isEditingFullName = false;
  bool _isEditingPhoneNumber = false;
  bool _isEditingSex = false;
  bool _isEditingBirthday = false;

  // bool _isEditingSex = false;

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

  void chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      showTopNotification(
        context: context,
        message: 'No image is picked',
        type: NotificationType.error,
      );
    } else {
      setState(() {
        image = File(pickedFile.path);
      });
      // Hiển thị dialog với ảnh được chọn
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          bool _isLoadingImage = false;
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return Container(
                child: AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  // ✅ (đôi khi cần set cả ở đây)
                  titlePadding: EdgeInsets.zero,
                  // ✅ Xoá padding tiêu đề
                  contentPadding: EdgeInsets.zero,
                  // ✅ Xoá padding nội dung
                  title: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: HelpersColors.itemPrimary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Are you sure',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Hiển thị ảnh được chọn
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child:
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: HelpersColors.itemPrimary, width: 2),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            child: Image.file(
                              File(pickedFile.path),
                              height: 300,
                              width: 250,// Kích thước ảnh trong dialog
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 16),
                      Text(
                        'Are you can save this image',
                        style: TextStyle(color: HelpersColors.itemPrimary, fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  image = null;
                                });
                                Navigator.of(context).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: HelpersColors.itemPrimary),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: HelpersColors.itemPrimary),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Thêm độ trễ tối thiểu để đảm bảo CircularProgressIndicator hiển thị
                                setDialogState(() {
                                  _isLoadingImage  = true;
                                });

                                await Future.delayed(Duration(milliseconds: 100));

                                final statusUploadBirthday = await AuthController()
                                    .updateInformationImage(
                                  ref: ref,
                                  id: ref.read(userProvider)!.id,
                                  image: image!,
                                );
                                if (statusUploadBirthday) {
                                  showTopNotification(
                                    context: context,
                                    message: 'Image saved successfully',
                                    type: NotificationType.success,
                                  );
                                } else {
                                  showTopNotification(
                                    context: context,
                                    message: 'Image saved fail',
                                    type: NotificationType.error,
                                  );
                                }
                                setDialogState(() {
                                  _isLoadingImage  = false;
                                });

                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HelpersColors.itemPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child:
                              _isLoadingImage ? Center(child: CircularProgressIndicator(color: Colors.white)) :
                              Text(
                                'Confirm',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],),
                      )
                    ],
                  ),

                ),
              );
            }

          );
        },
      );
    }
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    // 👇 Ngày mặc định hiển thị khi mở picker (1/1/2000)
    final initialDate = DateTime(2000, 1, 1);
    final firstDay = DateTime(now.year - 100, now.month, now.day);
    final pickerDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDay,
      lastDate: now,
    );
    setState(() {
      _birthDay = pickerDate;
    });
  }

  void _saveFullName() async {
    if (_fullNameFieldKey.currentState != null &&
        _fullNameFieldKey.currentState!.validate()) {
      final statusUploadFullName = await AuthController()
          .updateInformationFullName(
            ref: ref,
            id: ref.read(userProvider)!.id,
            fullName: _fullNameController.text,
          );
      if (statusUploadFullName) {
        showTopNotification(
          context: context,
          message: 'Full name saved successfully',
          type: NotificationType.success,
        );
      } else {
        showTopNotification(
          context: context,
          message: 'Full name saved fail',
          type: NotificationType.error,
        );
      }
    }
  }

  void _savePhoneNumber() async {
    if (_phoneNumberFieldKey.currentState != null &&
        _phoneNumberFieldKey.currentState!.validate()) {
      final statusUploadPhoneNumber = await AuthController()
          .updateInformationPhoneNumber(
            ref: ref,
            id: ref.read(userProvider)!.id,
            phoneNumber: _phoneNumberController.text,
          );
      if (statusUploadPhoneNumber) {
        showTopNotification(
          context: context,
          message: 'Phone Number saved successfully',
          type: NotificationType.success,
        );
      } else {
        showTopNotification(
          context: context,
          message: 'Phone Number saved fail',
          type: NotificationType.error,
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = ref.read(userProvider);
    _fullNameController = TextEditingController(text: user?.fullName ?? '');
    _phoneNumberController = TextEditingController(
      text: user?.phoneNumber ?? '',
    );
    _emailController = TextEditingController(text: user?.email ?? '');
    // _positionController = TextEditingController(
    //   text: (user?.image == null || user!.image.trim().isEmpty)
    //       ? 'Unset'
    //       : user.image,
    // );

    _focusNodeFullName = FocusNode();
    _focusNodePhoneNumber = FocusNode();

    _focusNodeFullName.addListener(() {
      if (!_focusNodeFullName.hasFocus) {
        _fullNameFieldKey.currentState?.validate();
      }
    });
    _focusNodePhoneNumber.addListener(() {
      if (!_focusNodeFullName.hasFocus) {
        _phoneNumberFieldKey.currentState?.validate();
      }
    });

    _positionController = TextEditingController(text: 'Unset');
    _birthDay = user?.birthDay ?? null;
    _passwordController = TextEditingController();
    _selectedSex = user?.sex ?? null;
    _focusNodeFullName = FocusNode();
    _focusNodePhoneNumber = FocusNode();
  }

  // void _updateInfo() async {
  //   // Kiểm tra validation của form
  //   // if (_formKey.currentState?.validate() != true) {
  //   //   showTopNotification(
  //   //     context: context,
  //   //     message: 'Please fix the errors in the form.',
  //   //     type: NotificationType.error,
  //   //   );
  //   //   return;
  //   // }
  //
  //   final updatedFields = <String>[];
  //   final user = ref.read(userProvider);
  //
  //   final fullName = _fullNameController.text.trim();
  //   if (fullName.isNotEmpty && fullName != user!.fullName) {
  //     updatedFields.add("Full Name");
  //   }
  //   // else{
  //   //   showTopNotification(context: context, message: "Error full name", type: NotificationType.error);
  //   //   return;
  //   // }
  //
  //   final phone = _phoneNumberController.text.trim();
  //   if (phone.isNotEmpty && phone != user!.phoneNumber) {
  //     updatedFields.add("Phone Number");
  //   }
  //
  //   // if (_selectedSex.isNotEmpty && _selectedSex != user!.sex) {
  //   //   updatedFields.add("Sex");
  //   // }
  //
  //   if (_birthDay != null && _birthDay != user!.birthDay) {
  //     updatedFields.add("Birthday");
  //   }
  //
  //   if (image != null && image != user!.image) {
  //     updatedFields.add("Avatar");
  //   }
  //
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   // Nếu update User thành công.
  //   final updateUser = await AuthController().updateInformationUser(
  //     ref: ref,
  //     id: user!.id,
  //     fullName: fullName.isNotEmpty ? fullName : null,
  //     phoneNumber: phone.isNotEmpty ? phone : null,
  //     // sex: _selectedSex.isNotEmpty ? _selectedSex : null,
  //     birthDay: _birthDay != user.birthDay ? _birthDay : null,
  //     image: image,
  //   );
  //
  //   setState(() {
  //     _isLoading = false;
  //   });
  //
  //   if (updateUser) {
  //     // // Tạo user mới từ dữ liệu cũ + giá trị mới
  //     // final updatedUser = user.copyWith(
  //     //   fullName: fullName.isNotEmpty ? fullName : user.fullName,
  //     //   phoneNumber: phone.isNotEmpty ? phone : user.phoneNumber,
  //     //   sex: _selectedSex.isNotEmpty ? _selectedSex : user.sex,
  //     //   birthDay: _birthDay ?? user.birthDay,
  //     //   image: image != null ? image!.path : user.image,
  //     // );
  //
  //     // Cập nhật vào Riverpod
  //     // ref.read(userProvider.notifier).updateUser(updatedUser);
  //     if (updatedFields.isNotEmpty) {
  //       // Thông báo thành công và liệt kê các trường đã cập nhật
  //       final updatedText = updatedFields.join(', ');
  //       showTopNotification(
  //         context: context,
  //         message: 'Update successfully : $updatedText',
  //         type: NotificationType.success,
  //       );
  //     } else {
  //       // Không có trường nào thay đổi
  //       showTopNotification(
  //         context: context,
  //         message: 'No changes were made.',
  //         type: NotificationType.success,
  //       );
  //     }
  //   } else {
  //     showTopNotification(
  //       context: context,
  //       message: 'Update failed. Please try again.',
  //       type: NotificationType.error,
  //     );
  //   }
  // }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: HelpersColors.itemPrimary,
    //     statusBarIconBrightness: Brightness.light,
    //   ),
    // );
    final user = ref.watch(userProvider)!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: HelpersColors.itemPrimary,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            'Information',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                      // Image.asset(
                      //   'assets/images/bg_1.png',
                      //   height: 250,
                      //   width: double.infinity,
                      //   fit: BoxFit.cover,
                      // ),
                      // Center(
                      //   child: Text(
                      //     'App Daily Manage',
                      //     style: TextStyle(
                      //       color: HelpersColors.itemPrimary,
                      //       fontSize: 30,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.6),
                                  width: 4,
                                ),
                              ),
                              child: ClipOval(
                                child: Image(
                                  image: image != null
                                      ? FileImage(
                                          image!,
                                        ) // ảnh vừa chọn từ gallery
                                      : (user.image == null ||
                                                user.image.isEmpty ||
                                                user.image == "null"
                                            ? AssetImage(
                                                    user.sex == 'Male'
                                                        ? 'assets/images/avatar_boy_default.jpg'
                                                        : user.sex == "Female"
                                                        ? 'assets/images/avatar_girl_default.jpg'
                                                        : 'assets/images/avt_default_2.jpg',
                                                  )
                                                  as ImageProvider
                                            : NetworkImage(user.image)),

                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  chooseImage();
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: Icon(
                                    Icons.upload_rounded,
                                    color: Colors.white,
                                  ),
                                  decoration: BoxDecoration(
                                    color: HelpersColors.itemPrimary,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (user?.fullName == null ||
                                      user!.fullName.trim().isEmpty)
                                  ? 'New User'
                                  : user.fullName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // SizedBox(width: 60),
                            // Text(
                            //   '18',
                            //   style: TextStyle(
                            //     color: Colors.blue,
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            // Icon(Icons.male, color: Colors.blue),
                          ],
                        ),
                      ),

                      //Email
                      // SizedBox(height: 15),
                      _buildTextFile('Email'),
                      TextFormField(
                        readOnly: true,
                        controller: _emailController,
                        onChanged: (value) {
                          // _email = value;
                        },
                        validator: (value) {
                          // return user.emailValidate(value);
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
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: HelpersColors.bgFillTextField,
                              width: 1.0,
                            ),
                          ),
                          // hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color: HelpersColors.itemTextField.withOpacity(0.8),
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: HelpersColors.itemTextField,
                          ),
                        ),
                      ),

                      //Position
                      _buildTextFile('Position'),
                      TextFormField(
                        readOnly: true,
                        controller: _positionController,
                        onChanged: (value) {
                          // _email = value;
                        },
                        validator: (value) {
                          // return user.emailValidate(value);
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
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: HelpersColors.bgFillTextField,
                              width: 1.0,
                            ),
                          ),
                          // hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color: HelpersColors.itemTextField.withOpacity(0.8),
                          ),
                          prefixIcon: Icon(
                            Icons.work,
                            color: HelpersColors.itemTextField,
                          ),
                        ),
                      ),

                      //Full Name
                      _buildTextFile('Full Name'),
                      TextFormField(
                        key: _fullNameFieldKey,
                        focusNode: _focusNodeFullName,
                        controller: _fullNameController,
                        readOnly: !_isEditingFullName,
                        onChanged: (value) {
                          // _fullName = value;
                        },
                        validator: (value) {
                          return user.fullNameValidate(value);
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
                          hintText: 'Edit your FullName',
                          hintStyle: TextStyle(
                            color: HelpersColors.itemTextField.withOpacity(0.8),
                          ),
                          prefixIcon: Icon(
                            Icons.text_fields_sharp,
                            color: HelpersColors.itemTextField,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isEditingFullName)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _saveFullName();
                                      _isEditingFullName = false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.save,
                                    color: HelpersColors.itemPrimary,
                                  ),
                                ),
                              IconButton(
                                icon: Icon(
                                  _isEditingFullName ? Icons.edit : Icons.edit,
                                  color: _isEditingFullName
                                      ? HelpersColors.itemPrimary
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isEditingFullName = !_isEditingFullName;
                                    // Khi nhấn chỉnh sửa full name, thì tại phone cx phải reset
                                    _isEditingPhoneNumber = false;
                                  });
                                  if (_isEditingFullName) {
                                    Future.delayed(
                                      Duration(milliseconds: 100),
                                      () {
                                        _focusNodeFullName
                                            .requestFocus(); // ✅ focus đúng node
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildTextFile('Phone Number'),
                      TextFormField(
                        key: _phoneNumberFieldKey,
                        focusNode: _focusNodePhoneNumber,
                        controller: _phoneNumberController,
                        readOnly: !_isEditingPhoneNumber,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          // _fullName = value;
                        },
                        validator: (value) {
                          return user.phoneNumberValidate(value);
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
                          hintText: 'Edit your phone number',

                          hintStyle: TextStyle(
                            color: HelpersColors.itemTextField.withOpacity(0.8),
                          ),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: HelpersColors.itemTextField,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isEditingPhoneNumber)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _savePhoneNumber();
                                      // _saveFullName();
                                      _isEditingPhoneNumber = false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.save,
                                    color: HelpersColors.itemPrimary,
                                  ),
                                ),
                              IconButton(
                                icon: Icon(
                                  _isEditingPhoneNumber
                                      ? Icons.edit
                                      : Icons.edit,
                                  color: _isEditingPhoneNumber
                                      ? HelpersColors.itemPrimary
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isEditingPhoneNumber =
                                        !_isEditingPhoneNumber;
                                    _isEditingFullName = false;
                                  });
                                  if (_isEditingPhoneNumber) {
                                    Future.delayed(
                                      Duration(milliseconds: 100),
                                      () {
                                        _focusNodePhoneNumber
                                            .requestFocus(); // ✅ focus đúng node
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildTextFile('Sex'),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: HelpersColors.bgFillTextField,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: !_isEditingSex
                                  ? null
                                  : () async {
                                      setState(() {
                                        _isEditingFullName = false;
                                        _isEditingPhoneNumber = false;
                                      });

                                      final selected =
                                          await showModalBottomSheet<String>(
                                            context: context,
                                            builder: (context) {
                                              return SafeArea(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: sex.map((item) {
                                                    return ListTile(
                                                      title: Text(item),
                                                      selected: item == _selectedSex, // ✅ đánh dấu nếu là item đang chọn
                                                      trailing: item == _selectedSex
                                                          ? const Icon(Icons.check, color: Colors.blue) // ✅ icon check
                                                          : null,
                                                      onTap: () {
                                                        Navigator.pop(
                                                          context,
                                                          item,
                                                        );
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                              );
                                            },
                                          );

                                      if (selected != null) {
                                        setState(() {
                                          _selectedSex = selected;
                                        });
                                      }
                                    },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.transgender,
                                    color: HelpersColors.itemTextField,
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    _selectedSex ?? 'Edit your sex',
                                    style: TextStyle(
                                      color: HelpersColors.itemTextField,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  if (_isEditingSex)
                                    Icon(
                                      Icons.expand_more_rounded,
                                      color: HelpersColors.itemPrimary,
                                    ),
                                ],
                              ),
                            ),

                            Spacer(),
                            if (_isEditingSex)
                              InkWell(
                                onTap: () async {
                                  if (_selectedSex == null) {
                                    showTopNotification(
                                      context: context,
                                      message: 'Please select a sex type',
                                      type: NotificationType.error,
                                    );
                                    return;
                                  }
                                  final statusUploadSex = await AuthController()
                                      .updateInformationSex(
                                        ref: ref,
                                        id: ref.read(userProvider)!.id,
                                        sex: _selectedSex!,
                                      );
                                  if (statusUploadSex) {
                                    showTopNotification(
                                      context: context,
                                      message: 'Sex saved successfully',
                                      type: NotificationType.success,
                                    );
                                  } else {
                                    showTopNotification(
                                      context: context,
                                      message: 'Sex saved fail',
                                      type: NotificationType.error,
                                    );
                                  }
                                  setState(() {
                                    _isEditingSex = !_isEditingSex;
                                  });
                                },
                                child: Icon(
                                  Icons.save,
                                  color: HelpersColors.itemPrimary,
                                ),
                              ),
                            SizedBox(width: 20),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isEditingSex = !_isEditingSex;
                                });
                              },
                              child: Icon(
                                Icons.edit,
                                color: _isEditingSex
                                    ? HelpersColors.itemPrimary
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildTextFile('Birthday'),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              // border:Border.all(color: HelpersColors.itemSelected, width: 1),
                              color: HelpersColors.bgFillTextField,
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: !_isEditingBirthday
                                      ? null
                                      : () {
                                          setState(() {
                                            _isEditingFullName = false;
                                            _isEditingPhoneNumber = false;
                                          });

                                          _presentDatePicker();
                                        },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color: HelpersColors.itemTextField,
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        _birthDay == null
                                            ? ' Edit your birthday'
                                            : FormatHelper.formatDate_DD_MM_YYYY(
                                                _birthDay!,
                                              ),
                                        // _birthDay == null
                                        //     ? 'Birthday'
                                        //     : FormatHelper.formatDate_DD_MM_YYYY(_birthDay!),
                                        style: TextStyle(
                                          color: HelpersColors.itemTextField,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      if (_isEditingBirthday)
                                        Icon(
                                          Icons.expand_more,
                                          color: HelpersColors.itemPrimary,
                                        ),
                                    ],
                                  ),
                                ),

                                Spacer(),
                                if (_isEditingBirthday)
                                  InkWell(
                                    onTap: () async {
                                      if (_birthDay == null) {
                                        showTopNotification(
                                          context: context,
                                          message:
                                              'Please select your birthday',
                                          type: NotificationType.error,
                                        );
                                      }
                                      // showTopNotification(context: context, message: 'hello', type: NotificationType.success);
                                      final statusUploadBirthday =
                                          await AuthController()
                                              .updateInformationBirthday(
                                                ref: ref,
                                                id: ref.read(userProvider)!.id,
                                                birthDay: _birthDay!,
                                              );
                                      if (statusUploadBirthday) {
                                        showTopNotification(
                                          context: context,
                                          message:
                                              'Birthday saved successfully',
                                          type: NotificationType.success,
                                        );
                                      } else {
                                        showTopNotification(
                                          context: context,
                                          message: 'Birthday saved fail',
                                          type: NotificationType.error,
                                        );
                                      }
                                    },
                                    child: Icon(
                                      Icons.save,
                                      color: HelpersColors.itemPrimary,
                                    ),
                                  ),
                                SizedBox(width: 20),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isEditingBirthday = !_isEditingBirthday;
                                    });
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: _isEditingBirthday
                                        ? HelpersColors.itemPrimary
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: InkWell(
        //     onTap: () {
        //       _updateInfo();
        //       // _isLoading ? null : _register();
        //       // _isLoading ? null : _register();
        //     },
        //     child: Container(
        //       padding: EdgeInsets.all(15),
        //       decoration: BoxDecoration(
        //         color: HelpersColors.itemPrimary,
        //         borderRadius: BorderRadius.all(Radius.circular(10)),
        //       ),
        //       child: Row(
        //         children: [
        //           Spacer(),
        //           _isLoading
        //               ? SizedBox(
        //             height: 24,
        //             width: 24,
        //             child: CircularProgressIndicator(
        //               color: Colors.white,
        //               strokeWidth: 2.5,
        //             ),
        //           )
        //               : Text(
        //             'Information Update',
        //             style: TextStyle(
        //               color: Colors.white,
        //               fontWeight: FontWeight.bold,
        //               fontSize: 16,
        //             ),
        //           ),
        //           Spacer(),
        //           Icon(
        //             Icons.arrow_right_alt,
        //             color: Colors.white,
        //             size: 30,
        //           ),
        //           SizedBox(width: 20),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
