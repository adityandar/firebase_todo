import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo/cubit/todo/todo_cubit.dart';
import 'package:firebase_todo/cubit/user/user_cubit.dart';
import 'package:firebase_todo/pages/auth/register_page.dart';
import 'package:firebase_todo/pages/todo/edit_todo_page.dart';
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
            showToast("New todo has been added");
          } else if (state is SuccessUpdateTodoState) {
            showToast("A todo has been updated");
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
                        handleNavigation(
                          page: RegisterPage(),
                          isRemoveUntil: true,
                        );
                      },
                      child: Text("Log Out"),
                    ),
                  );
                }
                return ListTile(
                  title: GestureDetector(
                    child: Text(state.todos[idx].title),
                    onTap: () {
                      handleNavigation(
                        page: EditTodoPage(
                          todo: state.todos[idx],
                          user: widget.user,
                        ),
                      );
                    },
                  ),
                  leading: Checkbox(
                    value: state.todos[idx].done,
                    onChanged: (bool? change) {
                      if (change != null) {
                        context
                            .read<TodoCubit>()
                            .changeTodoStatus(state.todos[idx], change);
                      }
                    },
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      context
                          .read<TodoCubit>()
                          .deleteTodo(state.todos[idx].id!);
                    },
                    icon: Icon(Icons.close),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          handleNavigation(
            page: NewTodoPage(user: widget.user),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void handleNavigation({
    required Widget page,
    bool? isRemoveUntil,
  }) {
    if (isRemoveUntil ?? false) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
          (route) => false);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    }
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: primaryColor,
      textColor: whiteColor,
      fontSize: 16.0,
    );
  }
}
