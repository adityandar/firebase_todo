import 'package:firebase_todo/cubit/user/user_cubit.dart';
import 'package:firebase_todo/pages/todo/main_todo_page.dart';
import 'package:firebase_todo/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Form(
            key: _formKey,
            child: BlocConsumer<UserCubit, UserState>(
              listener: (context, state) {
                if (state is SuccessUserState) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainTodoPage(user: state.user),
                      ),
                      (route) => false);
                }
              },
              builder: (context, state) {
                if (state is FailureUserState) {
                  Fluttertoast.showToast(
                    msg: state.errorMessage,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: primaryColor,
                    textColor: whiteColor,
                    fontSize: 16.0,
                  );
                }
                return ListView(
                  children: [
                    SizedBox(
                      height: 64,
                    ),
                    Center(
                      child: Text("Register"),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value! == "") {
                          return "Email can't be empty.";
                        } else {
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return "Email is not valid.";
                          }
                        }
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value! == "") {
                          return "Password can't be empty.";
                        } else {
                          if (value.length < 6) {
                            return "Password can't be less than 6 characters";
                          }
                        }
                      },
                    ),
                    SizedBox(height: 64),
                    ElevatedButton(
                      onPressed: (state is LoadingRegisterUserState)
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<UserCubit>().register(
                                    _emailController.text,
                                    _passwordController.text);
                              }
                            },
                      child: (state is LoadingRegisterUserState)
                          ? CircularProgressIndicator()
                          : Text("Register"),
                    ),
                    ElevatedButton(
                      onPressed: (state is LoadingLoginUserState)
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<UserCubit>().login(
                                    _emailController.text,
                                    _passwordController.text);
                              }
                            },
                      child: (state is LoadingLoginUserState)
                          ? CircularProgressIndicator()
                          : Text("Login"),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
