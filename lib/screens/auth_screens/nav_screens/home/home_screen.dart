import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/home/widgets/body_home_widget.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/home/widgets/header_home_widget.dart';
import 'package:daily_manage_user_app/screens/auth_screens/widgets/todo_list_table_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
                  children: [
                    HeaderHomeWidget(),
                    BodyHomeWidget(),
                    SizedBox(height: 30,),
                    TodoListTableWidget()
                  ]),
        ),
      ),
    );
  }
}
