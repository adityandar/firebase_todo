import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo/model/todo_model.dart';

abstract class TodoRepository {
  void addTodo(TodoModel todo);
  void updateTodo(TodoModel todo);
  void deleteTodo(String todoId);
  Stream<QuerySnapshot> changesOnTodo(String userId);
}
