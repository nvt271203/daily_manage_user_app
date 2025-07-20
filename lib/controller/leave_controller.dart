import 'dart:convert';

import 'package:daily_manage_user_app/global_variables.dart';
import 'package:daily_manage_user_app/models/leave.dart';
import 'package:daily_manage_user_app/screens/common_screens/widgets/top_notification_widget.dart';
import 'package:daily_manage_user_app/services/manage_http_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class LeaveController {
  Future<List<Leave>> loadLeavesByUser({required String userId})async{
    try{
      http.Response response = await http.get(Uri.parse('$uri/api/leave/$userId'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      print('body - ${response.body.toString()}');
      if(response.statusCode == 200){
        List<dynamic> leaves = jsonDecode(response.body);
        if(leaves.isNotEmpty){
          return leaves.map((leave) => Leave.fromMap(leave),).toList();
        }else{
          print('list leave not found');
          return [];
        }
      }else if(response.statusCode == 404){
        print('list leave not found');
        return [];
      }else{
        throw Exception('Failed to load leaves');
        return [];

      }
    }catch(e){
      print('Error request-response auth loadLeavesByUser: $e');
      return [];
    }
  }
  Future<bool> deleteLeave(String id)async {
    try{
     http.Response response = await http.delete(Uri.parse('$uri/api/leave/$id'),
        headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      }, );
     if (response.statusCode == 200) {
       return true;
     } else {
       print('Failed to delete. Status code: ${response.statusCode}');
       return false;
     }
    }catch(e){
      print('Error request-response auth loadLeavesByUser: $e');
      return false;
    }
  }
  
  Future<void> requestLeave({
    required BuildContext context,
    required DateTime dateCreated,
    required String leaveType,
    required String leaveTimeType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    required String userId,
  }) async {
    Leave leave = Leave(
      id: '',
      dateCreated: dateCreated,
      startDate: startDate,
      endDate: endDate,
      leaveType: leaveType,
      leaveTimeType: leaveTimeType,
      reason: reason,
      status: '',
      userId: userId,
    );
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/leave'),
        body: leave.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      print('body - ${response.body.toString()}');
      if(response.statusCode == 200 || response.statusCode == 201){
        manageHttpResponse(response, context, () {
          // showSnackBar(context, 'leave request success');
          showTopNotification(context: context, message: 'You have successfully added a new leave request.', type: NotificationType.success);
        },);
      }
    } catch (e) {
      print('Error request-response leave: $e');
    }
  }
  Future<bool> updateLeave({
    required BuildContext context,
    required DateTime dateCreated,
    required String leaveType,
    required String leaveTimeType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    required String userId,
    required String id
})async{
    Leave leave = Leave(
      id: id,
      dateCreated: dateCreated,
      startDate: startDate,
      endDate: endDate,
      leaveType: leaveType,
      leaveTimeType: leaveTimeType,
      reason: reason,
      status: '',
      userId: userId,
    );
    try{
      http.Response response = await http.put(Uri.parse('$uri/api/leave/$id'),
        body: leave.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },);
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete. Status code: ${response.statusCode}');
        return false;
      }
    }catch(e){
      print('Error request-put-response leave: $e');
      return false;
    }
  }


}
