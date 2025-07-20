import 'package:http/http.dart' as http;

import '../global_variables.dart';
class ConnectController {
  Future<bool> checkBackendConnection()async{
    try{

      http.Response response =await http.get(Uri.parse('$uri/api/ping'),headers: <String,String>{
        "Content-Type": "application/json; charset=UTF-8",
      });
      if(response.statusCode == 200){
        print('Connect backend success.');
        return true;
      }else {
        print('❌ Backend trả về mã lỗi: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Không kết nối được backend: $e');
      return false;
    }
  }
}