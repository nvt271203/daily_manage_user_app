import 'package:daily_manage_user_app/controller/leave_controller.dart';
import 'package:daily_manage_user_app/helpers/format_helper.dart';
import 'package:daily_manage_user_app/helpers/tools_colors.dart';
import 'package:daily_manage_user_app/models/leave.dart';
import 'package:daily_manage_user_app/providers/user_provider.dart';
import 'package:daily_manage_user_app/screens/common_screens/widgets/top_notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveRequestScreen extends ConsumerStatefulWidget {
  const LeaveRequestScreen( {super.key, this.leave,});
  final Leave? leave;

  @override
  _LeaveRequestScreenState createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends ConsumerState<LeaveRequestScreen> {
  // Kiểm tra nếu có dữ liệu gửi để hiện chi tiết.

  LeaveController _leaveController = LeaveController();
  String? _leaveType;
  String? _leaveTimeType;

  late DateTime dateCreated;
  TimeOfDay? _startTime; // giờ bắt đầu
  DateTime? _startDate;

  TimeOfDay? _endTime; // giờ kết thúc
  DateTime? _endDate;


  String _textErrorDayStart = 'Day start is required';
  String _textErrorDayEnd = 'Day End is required';
  String _textErrorTimeStart = 'Time start is required';
  String _textErrorTimeEnd = 'Time End is required';

  late DateTime? _fullStartDateTime;
  late DateTime? _fullEndDateTime;
  late String _reason;
  bool _isLoading = false;
  bool _errorLeaveType = false;
  bool _errorLeaveTimeType = false;
  bool _errorStartTime = false;
  bool _errorStartDate = false;
  bool _errorEndTime = false;
  bool _errorEndDate = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.leave != null){
      final leave = widget.leave!;
      setState(() {
        _leaveType = leave.leaveType;
        _leaveTimeType = leave.leaveTimeType;
        _startDate = leave.startDate;
        _endDate = leave.endDate;
        _startTime = TimeOfDay(hour: leave.startDate.hour, minute: leave.startDate.minute);
        _endTime = TimeOfDay(hour: leave.endDate.hour, minute: leave.endDate.minute);
        _reason = leave.reason ?? '';
        _fullStartDateTime = leave.startDate;
        _fullEndDateTime = leave.endDate;
      });
    }
  }


  void _chooseStartTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {

      // Nếu ngày bắt đầu và kết thúc giống nhau, kiểm tra thời gian
      if (_endTime != null && _startDate != null && _endDate != null && _startDate!.isAtSameMomentAs(_endDate!)) {
        final pickedDateTime = DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute);
        final endDateTime = DateTime(0, 0, 0, _endTime!.hour, _endTime!.minute);

        if (pickedDateTime.isAfter(endDateTime) || pickedDateTime.isAtSameMomentAs(endDateTime)) {
          setState(() {
            _errorStartTime = true;
            _textErrorTimeStart = 'Start time must be before end time when dates are the same';
          });

          showTopNotification(
            context: context,
            message: 'Start time must be before end time when dates are the same',
            type: NotificationType.error,
          );
          return;
        }
      }

      setState(() {
        _startTime = pickedTime;
        // 👉 Nếu thời gian không phải là 8:30 thì đổi sang Part Time
        if (!(pickedTime.hour == 8 && pickedTime.minute == 30)) {
          _leaveTimeType = 'Part Time';
        }
      });


      // if (_startDate != null) {
      //   // Cập nhật lại _startDate kèm giờ
      //   final newDate = DateTime(
      //     _startDate!.year,
      //     _startDate!.month,
      //     _startDate!.day,
      //     pickedTime.hour,
      //     pickedTime.minute,
      //   );
      //   setState(() {
      //     _startDate = newDate;
      //   });
      // }
    }


  }
  // void _chooseEndTimePicker() async {
  //   final pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (pickedTime != null) {
  //
  //     if (pickedTime != null) {
  //       // Nếu ngày bắt đầu và kết thúc giống nhau, kiểm tra thời gian
  //       if (_startTime != null &&
  //           _startDate != null &&
  //           _endDate != null &&
  //           _startDate!.isAtSameMomentAs(_endDate!)) {
  //         final startDateTime = DateTime(
  //             0, 0, 0, _startTime!.hour, _startTime!.minute);
  //         final pickedDateTime = DateTime(
  //             0, 0, 0, pickedTime.hour, pickedTime.minute);
  //
  //         if (pickedDateTime.isBefore(startDateTime) ||
  //             pickedDateTime.isAtSameMomentAs(startDateTime)) {
  //           setState(() {
  //             _errorEndTime = true;
  //             _textErrorTimeEnd =
  //             'End time must be after start time when dates are the same';
  //           });
  //
  //           showTopNotification(
  //             context: context,
  //             message: 'End time must be after start time when dates are the same',
  //             type: NotificationType.error,
  //           );
  //           return;
  //         }
  //       }
  //
  //
  //       setState(() {
  //         _endTime = pickedTime;
  //       });
  //     }
  //
  //
  //     // if (_startDate != null) {
  //     //   // Cập nhật lại _startDate kèm giờ
  //     //   final newDate = DateTime(
  //     //     _startDate!.year,
  //     //     _startDate!.month,
  //     //     _startDate!.day,
  //     //     pickedTime.hour,
  //     //     pickedTime.minute,
  //     //   );
  //     //   setState(() {
  //     //     _startDate = newDate;
  //     //   });
  //     // }
  //   }
  // }
  void _chooseEndTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      bool _isSameDate() =>
          _startDate != null &&
              _endDate != null &&
              _startDate!.year == _endDate!.year &&
              _startDate!.month == _endDate!.month &&
              _startDate!.day == _endDate!.day;

      if (_startTime != null && _isSameDate()) {
        final pickedDateTime = DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute);
        final startDateTime = DateTime(0, 0, 0, _startTime!.hour, _startTime!.minute);

        if (!pickedDateTime.isAfter(startDateTime)) {
          setState(() {
            _errorEndTime = true;
            _textErrorTimeEnd = 'End time must be after start time when dates are the same';
          });

          showTopNotification(
            context: context,
            message: 'End time must be after start time when dates are the same',
            type: NotificationType.error,
          );
          return;
        }
      }

      setState(() {
        _endTime = pickedTime;
        _errorEndTime = false;
        // 👉 Nếu thời gian không phải là 17:30 thì đổi sang Part Time
        if (!(pickedTime.hour == 17 && pickedTime.minute == 30)) {
          _leaveTimeType = 'Part Time';
        }
      });
    }
  }

  void _chooseDateStartPicker() async {
    final now = DateTime.now();
    final initialDate = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day); // Cắt bỏ giờ phút giây
    final lastDate = DateTime(now.year + 1);
    final pickerDate = await showDatePicker(
      initialDate: initialDate,
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickerDate != null) {
      final dateWithTime = DateTime(
        pickerDate.year,
        pickerDate.month,
        pickerDate.day,
        // now.hour,
        // now.minute,
        // now.second,

      );

      // ⏰ Kiểm tra nếu ngày bắt đầu == ngày kết thúc và giờ bắt đầu ≥ giờ kết thúc
      if (_endDate != null &&
          _startTime != null &&
          _endTime != null &&
          pickerDate.isAtSameMomentAs(DateTime(_endDate!.year, _endDate!.month, _endDate!.day))) {
        final startDateTime = DateTime(0, 0, 0, _startTime!.hour, _startTime!.minute);
        final endDateTime = DateTime(0, 0, 0, _endTime!.hour, _endTime!.minute);

        if (startDateTime.isAfter(endDateTime) || startDateTime.isAtSameMomentAs(endDateTime)) {
          setState(() {
            _textErrorDayStart = 'If the start time is greater than the end time, then the start date must be greater than the end date.';
            _errorStartDate = true;
          });

          showTopNotification(
            context: context,
            message: 'If the start time is greater than the end time, then the start date must be greater than the end date.',
            type: NotificationType.error,
          );
          return;
        }
      }else{
        _errorStartDate = false;
      }



// Kiểm tra ko cho phép chọn ngày bắt đầu lớn hơn ngày kết thúc
      if(_endDate != null && pickerDate.isAfter(_endDate!)){
        // _showInvalidDateDialog('Start date cannot be after end date.');
        setState(() {
          _textErrorDayStart = 'Start date cannot be after end date';
          _errorStartDate = true;

        });
        showTopNotification(context: context, message: 'Start date cannot be after end date', type: NotificationType.error);
        return;
      }else{
        _errorStartDate = false;
      }

      setState(() {
        _startDate = dateWithTime;
      });
    }
  }

  void _chooseDateEndPicker() async {
    final now = DateTime.now();
    final initialDate = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day); // Cắt bỏ giờ phút giây

    final lastDate = DateTime(now.year, now.month + 3, now.day);
    final pickerDate = await showDatePicker(
      initialDate: initialDate,
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickerDate != null) {
      final dateWithTime = DateTime(
        pickerDate.year,
        pickerDate.month,
        pickerDate.day,
        // now.hour,
        // now.minute,
        // now.second,

      );


      // ❌ Nếu ngày bắt đầu == ngày kết thúc và giờ kết thúc ≤ giờ bắt đầu
      if (_startDate != null &&
          _startTime != null &&
          _endTime != null &&
          dateWithTime.isAtSameMomentAs(DateTime(_startDate!.year, _startDate!.month, _startDate!.day))) {
        final startTimeDT = DateTime(0, 0, 0, _startTime!.hour, _startTime!.minute);
        final endTimeDT = DateTime(0, 0, 0, _endTime!.hour, _endTime!.minute);
        if (endTimeDT.isBefore(startTimeDT) || endTimeDT.isAtSameMomentAs(startTimeDT)) {
          setState(() {
            _textErrorDayEnd = 'If the start time is greater than the end time, then the end date must be greater than the start date.';
            _errorEndDate = true;
          });

          showTopNotification(
            context: context,
            message: 'End time must be after start time when dates are the same',
            type: NotificationType.error,
          );
          return;
        }
      }else{
        setState(() {
          _errorEndDate = false;
        });
      }





      // Không cho phép ngày kết thúc nhỏ hơn ngày bắt đầu.
      if(_startDate != null && dateWithTime.isBefore(_startDate!)){
        setState(() {
          _textErrorDayEnd = 'End date cannot be before start date';
          _errorEndDate = true;
        });
        showTopNotification(context: context, message: 'End date cannot be before start date', type: NotificationType.error);
        return;
      }else{
        setState(() {
          _errorEndDate = false;
        });
      }
      setState(() {
        _endDate = dateWithTime;
      });
    }
  }

  void _submit() async {
    if (_leaveType == null) {
      setState(() {
        _errorLeaveType = true;
      });
    } else {
      setState(() {
        _errorLeaveType = false;
      });
    }

    if (_leaveTimeType == null) {
      setState(() {
        _errorLeaveTimeType = true;
      });
    } else {
      setState(() {
        _errorLeaveTimeType = false;
      });
    }

    if (_startTime == null) {
      setState(() {
        _errorStartTime = true;
      });
    } else {
      setState(() {
        _errorStartTime = false;
      });
    }
    if (_startDate == null) {
      setState(() {
        _errorStartDate = true;
      });
    } else {
      setState(() {
        _errorStartDate = false;
      });
    }

    if (_endTime == null) {
      setState(() {
        _errorEndTime = true;
      });
    } else {
      setState(() {
        _errorEndTime = false;
      });
    }
    if (_endDate == null) {
      setState(() {
        _errorEndDate = true;
      });
    } else {
      setState(() {
        _errorEndDate = false;
      });
    }
    if(_startTime!=null && _startDate!=null){
      setState(() {
        _fullStartDateTime = DateTime(
            _startDate!.year,
            _startDate!.month,
            _startDate!.day,
            _startTime!.hour,
            _startTime!.minute
        );
      });
    }
    if(_endTime!=null && _endDate!=null){
      setState(() {
        _fullEndDateTime = DateTime(
            _endDate!.year,
            _endDate!.month,
            _endDate!.day,
            _endTime!.hour,
            _endTime!.minute
        );
      });
    }

    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() &&
        _leaveType != null &&
        _leaveTimeType != null &&
        _fullStartDateTime != null &&
        _fullEndDateTime != null) {
      final user = ref.read(userProvider); // ✅ thêm dòng này ở đầu
      setState(() {
        _isLoading = true;
      });
      print('_leaveType  - ${_leaveType}');
      print('_leaveTimeType  - ${_leaveTimeType}');
      print('_startDate  - ${_startDate}');
      print('_endDate  - ${_endDate}');
      print('_reason  - ${_reason}');


      if(widget.leave == null){
        // Truong hop them moi
        await _leaveController.requestLeave(
          context: context,
          dateCreated: DateTime.now(),
          leaveType: _leaveType!,
          leaveTimeType: _leaveTimeType!,
          startDate: _fullStartDateTime!,
          endDate: _fullEndDateTime!,
          reason: _reason,
          userId: user!.id,
        );
      }else{
        await _leaveController.updateLeave(
          context: context,
          dateCreated: DateTime.now(),
          leaveType: _leaveType!,
          leaveTimeType: _leaveTimeType!,
          startDate: _fullStartDateTime!,
          endDate: _fullEndDateTime!,
          reason: _reason,
          userId: user!.id,
          id: widget.leave!.id
        );
        showTopNotification(context: context, message: 'You have successfully updated a leave request.', type: NotificationType.success);

      }

      // ✅ Sau khi gửi xong, quay lại trang trước và trả về `true`
      if (context.mounted) {
        Navigator.pop(context, true);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: widget.leave == null ? const Text('Leave Request') :const Text('Update Leave Request'),
          centerTitle: true,
          backgroundColor: HelpersColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextTitle(title: 'Leave Type'),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: HelpersColors.bgFillTextField,
                          border: Border.all(
                            color: _errorLeaveType
                                ? HelpersColors.itemSelected
                                : HelpersColors.bgFillTextField,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: DropdownButton(
                          items: leaveType.map((e) {
                            return DropdownMenuItem(child: Text(e), value: e);
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _leaveType = value as String?);
                          },
                          hint: Center(child: Text('Choose Leave Type')),
                          value: _leaveType,
                          isExpanded: true,
      
                          dropdownColor: Colors.white,
                          underline: SizedBox(),
                        ),
                      ),
                      if (_errorLeaveType)
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            'Leave type is required',
                            style: TextStyle(color: HelpersColors.itemSelected),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
      
                  _buildTextTitle(title: 'Leave Time Type'),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: HelpersColors.bgFillTextField,
                          border: Border.all(
                            color: _errorLeaveTimeType
                                ? HelpersColors.itemSelected
                                : HelpersColors.bgFillTextField,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: DropdownButton(
                          items: leaveTimeType.map((e) {
                            return DropdownMenuItem(child: Text(e), value: e);
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _leaveTimeType = value as String?;
      
                              if (_leaveTimeType == 'Full Time') {
                                _startTime = TimeOfDay(hour: 8, minute: 30); // 🕗 8:30 AM
                                _endTime = TimeOfDay(hour: 17, minute: 30);  // 🕔 5:30 PM
      
                                _errorStartTime = false;
                                _errorEndTime = false;
                              }
                              if (_leaveTimeType == 'Part Time') {
                                _startTime = null; // 🕗 8:30 AM
                                _endTime = null;  // 🕔 5:30 PM
                              }
                            });
                          },
                          hint: Center(child: Text('Choose Leave Time Type')),
                          value: _leaveTimeType,
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          underline: SizedBox(),
                        ),
                      ),
                      if (_errorLeaveTimeType)
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            'Leave time type is required',
                            style: TextStyle(color: HelpersColors.itemSelected),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextTitle(title: 'Start Time'),
                            InkWell(
                              onTap: () {
                                _chooseStartTimePicker();
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: HelpersColors.bgFillTextField,
                                      border: Border.all(
                                        color: _errorStartTime
                                            ? HelpersColors.itemSelected
                                            : HelpersColors.bgFillTextField,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.access_time),
                                        SizedBox(width: 10),
                                        Text(
                                          _startTime == null
                                              ? 'Choose time'
                                              : _startTime!.format(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_errorStartTime)
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Text(
                                        _textErrorTimeStart,
                                        style: TextStyle(
                                          color: HelpersColors.itemSelected,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextTitle(title: 'Start Day'),
                            InkWell(
                              onTap: () {
                                _chooseDateStartPicker();
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: HelpersColors.bgFillTextField,
                                      border: Border.all(
                                        color: _errorStartDate
                                            ? HelpersColors.itemSelected
                                            : HelpersColors.bgFillTextField,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today),
                                        SizedBox(width: 10),
                                        Text(
                                          _startDate == null
                                              ? 'Choose day'
                                              : FormatHelper.formatDate_DD_MM_YYYY(
                                            _startDate!,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_errorStartDate)
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Text(
                                        _textErrorDayStart,
                                        style: TextStyle(
                                          color: HelpersColors.itemSelected,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextTitle(title: 'End time'),
                            InkWell(
                              onTap: () {
                                _chooseEndTimePicker();
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: HelpersColors.bgFillTextField,
                                      border: Border.all(
                                        color: _errorEndTime
                                            ? HelpersColors.itemSelected
                                            : HelpersColors.bgFillTextField,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.access_time_outlined),
                                        SizedBox(width: 10),
                                        Text(
                                          _endTime == null
                                              ? 'Choose time'
                                              : _endTime!.format(context),
      
                                  ),
                                      ],
                                    ),
                                  ),
                                  if (_errorEndTime)
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Text(
                                        _textErrorTimeEnd,
                                        style: TextStyle(
                                          color: HelpersColors.itemSelected,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextTitle(title: 'End Day'),
                            InkWell(
                              onTap: () {
                                _chooseDateEndPicker();
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: HelpersColors.bgFillTextField,
                                      border: Border.all(
                                        color: _errorEndDate
                                            ? HelpersColors.itemSelected
                                            : HelpersColors.bgFillTextField,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today),
                                        SizedBox(width: 10),
                                        Text(
                                          _endDate == null
                                              ? 'Choose day'
                                              : FormatHelper.formatDate_DD_MM_YYYY(
                                            _endDate!,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_errorEndDate)
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Text(
                                        _textErrorDayEnd,
                                        style: TextStyle(
                                          color: HelpersColors.itemSelected,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      
                  SizedBox(height: 20),
                  _buildTextTitle(title: 'Reason'),
                  TextFormField(
                    maxLines: 7,
                    onChanged: (value) {
                      _reason = value;
                    },
                    initialValue:widget.leave != null ? widget.leave!.reason : '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Reason is required';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: HelpersColors.itemPrimary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black26,
                          width: 1.0,
                        ),
                      ),
                      hintText: 'Please enter reason for leave',
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      _submit();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: HelpersColors.primaryColor,
                        gradient: LinearGradient(
                          colors: [
                            HelpersColors.primaryColor,
                            HelpersColors.secondaryColor,
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 50),
                          _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : Text( widget.leave == null ?
                                  'Leave request' : 'Update',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          Spacer(),
                          Icon(
                            Icons.arrow_right_alt,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(width: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextTitle({required String title}) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.black,fontSize: 15,),
          ),
          Text('  *', style: TextStyle(color: HelpersColors.itemSelected,fontSize: 15,),)
        ],
      ),
    );
  }
}
