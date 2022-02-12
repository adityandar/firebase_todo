import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo/cubit/todo/todo_cubit.dart';
import 'package:firebase_todo/model/todo_model.dart';
import 'package:firebase_todo/pages/todo/main_todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewTodoPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final User user;
  NewTodoPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: BlocConsumer<TodoCubit, TodoState>(
            listener: (context, state) {
              if (state is SuccessAddTodoState) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainTodoPage(user: user)),
                    (route) => false);
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "Title",
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value! == "") {
                        return "Title can't be empty.";
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: (state is LoadingTodoState)
                        ? null
                        : () {
                            context.read<TodoCubit>().addTodo(
                                  TodoModel(
                                    userId: user.uid,
                                    done: false,
                                    title: _titleController.text,
                                  ),
                                );
                          },
                    child: (state is LoadingTodoState)
                        ? CircularProgressIndicator()
                        : Text(
                            "Add",
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
