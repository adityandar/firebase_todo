import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_todo/cubit/user_cubit.dart';
import 'package:firebase_todo/firebase_options.dart';
import 'package:firebase_todo/pages/auth/register_page.dart';
import 'package:firebase_todo/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(_authService),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: RegisterPage(),
      ),
    );
  }
}
