import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainTodoPage extends StatelessWidget {
  final User user;
  const MainTodoPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(user.email!),
      ),
    );
  }
}
