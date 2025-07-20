import 'dart:convert';

import 'package:daily_manage_user_app/services/manage_http_response.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

import '../global_variables.dart';
import '../models/work.dart';

class WorkController {
  Future<bool> completeWork({
    required BuildContext context,
    required DateTime checkInTime,
    required DateTime checkOutTime,
    required Duration workTime,
    required String report,
    required String plan,
    String? note,
    required String userId,
  }) async {
    Work work = Work(
      id: '',
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      workTime: workTime,
      report: report,
      plan: plan,
      note: note!.isEmpty ? '' : note.trim(), // 👈 xử lý tại đây,
      userId: userId,
    );
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/work'),
        body: work.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('response - ${response.body.toString()}');
      // trả về true nếu upload dữ liệu thành công - nếu ko check mã trạng thái mà return thẳng true ở else thì dẫn đến dữ liệu upload thất bại nó cũng trả về true
      if(response.statusCode == 200 || response.statusCode == 201){
        // manageHttpResponse(response, context, () {
        //   showSnackBar(context, 'Checkout success');
        // },);
        return true;
      }else{
        return false;
      }

      // manageHttpResponse(response, context, () {
      //   showSnackBar(context, 'upload success');
      // });
      return true; // ✅ Trả về thành công
    } catch (e) {
      print('Error request-response auth work: $e');
      return false; // ✅ Trả về thất bại
    }
  }

  Future<List<Work>> loadWorkByUser({required String userId,

  }) async{
    try{
      http.Response response = await http.get(Uri.parse('$uri/api/work/$userId'),
        headers: <String, String>{
          'Content-Type':'application/json; charset=UTF-8'
        }
      );
      print('response - ${response.body.toString()}');
      if(response.statusCode == 200){
        List<dynamic> works = jsonDecode(response.body);
        if(works.isNotEmpty){
          return works.map((work) => Work.fromMap(work)).toList();
        }else{
          print('subcategories not found');
          return [];
        }
      } else if(response.statusCode == 404){
        print('subcategories not found');
        return [];

      } else{
        throw Exception('Failed to load categories');
        return [];

      }

    }catch(e){
      print('Error request-response auth loadWorkByUser: $e');
      return [];
    }
  }

  Future<bool> addCheckInWork({
    required BuildContext context,
    required DateTime checkInTime,
    required String userId,
  }) async {
    try {
      final body = {
        "checkInTime": checkInTime.toUtc().toIso8601String(),
        "userId": userId,
      };

      final response = await http.post(
        Uri.parse('$uri/api/work'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return true;
      }else{
        return false;
      }
    } catch (e) {
      print('Error check-in: $e');
      return false;
    }
  }

  Future<Work?> getCheckInByUser({
    required String userId,
    required DateTime checkInTime,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/work/active/$userId/${checkInTime.toLocal().toIso8601String()}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('response - ${response.body}');

      if (response.statusCode == 200) {
        final workJson = jsonDecode(response.body); // ✅ object, không phải list
        print('response200 - ${response.body}');

        return Work.fromMap(workJson);              // ✅ xử lý map
      } else if (response.statusCode == 404) {
        print('Work not found (404)');
        return null;
      } else {
        throw Exception('Failed to load work');
      }
    } catch (e) {
      print('Error request-response auth loadWorkByUser: $e');
      return null;
    }
  }
  Future<Work?> getCheckInByUserID({
    required String userId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/work/active/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('response - ${response.body}');

      if (response.statusCode == 200) {
        final workJson = jsonDecode(response.body); // ✅ object, không phải list
        print('response200 - ${response.body}');

        return Work.fromMap(workJson);              // ✅ xử lý map
      } else if (response.statusCode == 404) {
        print('Work not found (404)');
        return null;
      } else {
        throw Exception('Failed to load work');
      }
    } catch (e) {
      print('Error request-response auth loadWorkByUser: $e');
      return null;
    }
  }


  Future<bool> updateWorkByUser({
    required String id,
    DateTime? checkOutTime,
    Duration? workTime,
    String? report,
    String? plan,
    String? note,
  }) async {
    try {
      // Khởi tạo map rỗng và thêm các trường nếu không null
      Map<String, dynamic> updateFields = {};

      if (checkOutTime != null) {
        updateFields['checkOutTime'] = checkOutTime.toIso8601String();
      }

      if (workTime != null) {
        updateFields['workTime'] = workTime.inSeconds;
      }

      if (report != null) {
        updateFields['report'] = report.trim();
      }

      if (plan != null) {
        updateFields['plan'] = plan.trim();
      }

      if (note != null) {
        updateFields['note'] = note.trim().isEmpty ? '' : note.trim();
      }

      if (updateFields.isEmpty) {
        print('⚠️ Không có dữ liệu nào để cập nhật.');
        return false;
      }

      http.Response response = await http.put(
        Uri.parse('$uri/api/work/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updateFields),
      );

      print('✅ PUT response: ${response.statusCode} - ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Exception updateWorkByUser: $e');
      return false;
    }
  }

}
