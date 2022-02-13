import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo/cubit/todo/todo_cubit.dart';
import 'package:firebase_todo/model/todo_model.dart';
import 'package:firebase_todo/pages/todo/main_todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditTodoPage extends StatefulWidget {
  final User user;
  final TodoModel todo;

  EditTodoPage({
    Key? key,
    required this.user,
    required this.todo,
  }) : super(key: key);

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.todo.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: BlocConsumer<TodoCubit, TodoState>(
            listener: (context, state) {
              if (state is SuccessUpdateTodoState) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainTodoPage(user: widget.user)),
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
                            context.read<TodoCubit>().updateTodo(
                                  TodoModel(
                                    userId: widget.todo.userId,
                                    id: widget.todo.id,
                                    done: widget.todo.done,
                                    title: _titleController.text,
                                  ),
                                );
                          },
                    child: (state is LoadingTodoState)
                        ? CircularProgressIndicator()
                        : Text(
                            "Edit",
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
