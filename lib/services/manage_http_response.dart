import 'dart:convert';

import 'package:daily_manage_user_app/screens/common_screens/widgets/top_notification_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse(
    http.Response response, BuildContext context, VoidCallback onSuccess) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showTopNotification(context: context, message: json.decode(response.body)['message'], type: NotificationType.error);
      // showSnackBar(context, json.decode(response.body)['message']);
      print('msg receive: '+ json.decode(response.body)['message']);
      break;
    case 500:
      showSnackBar(context, json.decode(response.body)['error']);
      showTopNotification(context: context, message: json.decode(response.body)['message'], type: NotificationType.error);
      print('error receive: '+ json.decode(response.body)['error']);
      break;
    case 201:
      onSuccess();
      break;
  }
}
void showSnackBar(BuildContext context, String title){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
}
