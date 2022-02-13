import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_todo/cubit/todo/todo_cubit.dart';
import 'package:firebase_todo/cubit/user/user_cubit.dart';
import 'package:firebase_todo/firebase_options.dart';
import 'package:firebase_todo/pages/auth/register_page.dart';
import 'package:firebase_todo/pages/todo/main_todo_page.dart';
import 'package:firebase_todo/repository/auth/auth_repository.dart';
import 'package:firebase_todo/repository/auth/auth_repository_impl.dart';
import 'package:firebase_todo/repository/todo/todo_repository.dart';
import 'package:firebase_todo/repository/todo/todo_repository_impl.dart';
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

  final AuthRepository _authRepository = AuthRepositoryImpl();
  final TodoRepository _todoRepository = TodoRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCubit(_authRepository),
        ),
        BlocProvider(
          create: (context) => TodoCubit(_todoRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase Todo',
        home: StreamBuilder(
          stream: _authRepository.checkAuth(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.data != null) {
              return MainTodoPage(user: snapshot.data!);
            } else {
              return RegisterPage();
            }
          },
        ),
      ),
    );
  }
}
