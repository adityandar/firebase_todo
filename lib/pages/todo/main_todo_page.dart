import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo/cubit/todo/todo_cubit.dart';
import 'package:firebase_todo/cubit/user/user_cubit.dart';
import 'package:firebase_todo/pages/auth/register_page.dart';
import 'package:firebase_todo/pages/todo/new_todo_page.dart';
import 'package:firebase_todo/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainTodoPage extends StatefulWidget {
  final User user;
  const MainTodoPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MainTodoPage> createState() => _MainTodoPageState();
}

class _MainTodoPageState extends State<MainTodoPage> {
  @override
  void initState() {
    super.initState();
    context.read<TodoCubit>().listenToChanges(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          if (state is SuccessAddTodoState) {
            Fluttertoast.showToast(
              msg: "New todo has been added",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: primaryColor,
              textColor: whiteColor,
              fontSize: 16.0,
            );
            // context.read<TodoCubit>().getAllTodo(userId!);
          } else if (state is SuccessGetTodoState) {
            return ListView.builder(
              itemCount: state.todos.length + 1,
              itemBuilder: (context, idx) {
                if (idx == state.todos.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<UserCubit>().logout();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                            (route) => false);
                      },
                      child: Text("Log Out"),
                    ),
                  );
                }
                return ListTile(
                  title: Text(state.todos[idx].title),
                  leading: Checkbox(
                    value: state.todos[idx].done,
                    onChanged: (change) {
                      context
                          .read<TodoCubit>()
                          .changeTodoStatus(state.todos[idx]);
                    },
                  ),
                );
              },
            );
          } else if (state is LoadingTodoState) {}
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTodoPage(user: widget.user),
            ),
          );
        },
      ),
    );
  }
}
