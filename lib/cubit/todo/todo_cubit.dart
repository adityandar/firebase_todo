import 'package:equatable/equatable.dart';
import 'package:firebase_todo/model/todo_model.dart';
import 'package:firebase_todo/repository/todo/todo_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository _todoRepository;
  TodoCubit(this._todoRepository) : super(InitialTodoState());

  void addTodo(TodoModel todo) {
    emit(LoadingTodoState());
    try {
      _todoRepository.addTodo(todo);
      emit(SuccessAddTodoState());
    } catch (e) {
      //TODO: change this one.
      emit(FailureTodoState(errorMessage: e.toString()));
    }
  }

  void changeTodoStatus(TodoModel todo, bool done) {
    emit(LoadingTodoState());
    TodoModel newTodo = todo.copyWith(done: done);
    try {
      _todoRepository.updateTodo(newTodo);
      emit(SuccessUpdateTodoState());
    } catch (e) {
      //TODO: change this one.
      emit(FailureTodoState(errorMessage: e.toString()));
    }
  }

  void updateTodo(TodoModel todo) {
    emit(LoadingTodoState());
    try {
      _todoRepository.updateTodo(todo);
      emit(SuccessUpdateTodoState());
    } catch (e) {
      //TODO: change this one.
      emit(FailureTodoState(errorMessage: e.toString()));
    }
  }

  void deleteTodo(String todoId) {
    emit(LoadingTodoState());
    try {
      _todoRepository.deleteTodo(todoId);
      emit(SuccessDeleteTodoState());
    } catch (e) {
      //TODO: change this one.
      emit(FailureTodoState(errorMessage: e.toString()));
    }
  }

  void listenToChanges(String userId) async {
    _todoRepository.changesOnTodo(userId).listen((res) {
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
