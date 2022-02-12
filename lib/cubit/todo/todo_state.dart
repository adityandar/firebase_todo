part of 'todo_cubit.dart';

abstract class TodoState extends Equatable {}

class InitialTodoState extends TodoState {
  @override
  List<Object?> get props => [];
}

class LoadingTodoState extends TodoState {
  @override
  List<Object?> get props => [];
}

class FailureTodoState extends TodoState {
  final String errorMessage;

  FailureTodoState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class SuccessGetTodoState extends TodoState {
  List<TodoModel> todos;
  SuccessGetTodoState({required this.todos});
  @override
  List<Object?> get props => [];
}

class SuccessAddTodoState extends TodoState {
  SuccessAddTodoState();
  @override
  List<Object?> get props => [];
}

class SuccessUpdateTodoState extends TodoState {
  SuccessUpdateTodoState();
  @override
  List<Object?> get props => [];
}
