import 'package:firebase_todo/model/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo/repository/todo/todo_repository.dart';

class TodoRepositoryImpl extends TodoRepository {
  final CollectionReference _todoFirestore =
      FirebaseFirestore.instance.collection('todos');

  @override
  void addTodo(TodoModel todo) {
    _todoFirestore
        .add(todo.toJson())
        .then((value) => print("Todo Added"))
        .catchError((error) => print("Failed to add Todo: $error"));
  }

  @override
  Stream<QuerySnapshot<Object?>> changesOnTodo(String userId) {
    return _todoFirestore
        .where('userId', isEqualTo: userId)
        .orderBy('done', descending: false)
        .snapshots();
  }

  @override
  void updateTodo(TodoModel todo) {
    _todoFirestore
        .doc(todo.id)
        .update(todo.toJson())
        .then((value) => print("Todo Added"))
        .catchError((error) => print("Failed to add Todo: $error"));
  }

  @override
  void deleteTodo(String todoId) {
    _todoFirestore.doc(todoId).delete();
  }
}
