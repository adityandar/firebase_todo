import 'package:equatable/equatable.dart';
import 'package:firebase_todo/model/todo_model.dart';
import 'package:firebase_todo/services/todo_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoService _todoService;
  TodoCubit(this._todoService) : super(InitialTodoState());

  void addTodo(TodoModel todo) {
    emit(LoadingTodoState());
    try {
      _todoService.addTodo(todo);
      emit(SuccessAddTodoState());
    } catch (e) {
      //TODO: change this one.
      emit(FailureTodoState(errorMessage: e.toString()));
    }
  }

  void changeTodoStatus(TodoModel todo) {
    emit(LoadingTodoState());
    TodoModel newTodo = TodoModel(
      title: todo.title,
      done: !todo.done,
      userId: todo.userId,
      id: todo.id,
    );
    try {
      _todoService.updateTodo(newTodo);
      emit(SuccessUpdateTodoState());
    } catch (e) {
      //TODO: change this one.
      emit(FailureTodoState(errorMessage: e.toString()));
    }
  }

  void listenToChanges(String userId) async {
    _todoService.changesOnTodo(userId).listen((res) {
      emit(LoadingTodoState());
      List<TodoModel> todos = [];
      res.docs.forEach((doc) {
        todos.add(
          TodoModel(
            title: doc["title"],
            done: doc["done"],
            userId: doc["userId"],
            id: doc.id,
          ),
        );
      });
      emit(SuccessGetTodoState(todos: todos));
    });
  }
}
