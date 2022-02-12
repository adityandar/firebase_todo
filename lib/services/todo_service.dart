import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo/model/todo_model.dart';

class TodoService {
  final CollectionReference _todoFirestore =
      FirebaseFirestore.instance.collection('todos');

  void addTodo(TodoModel todo) {
    _todoFirestore
        .add(todo.toJson())
        .then((value) => print("Todo Added"))
        .catchError((error) => print("Failed to add Todo: $error"));
  }

  void updateTodo(TodoModel todo) {
    _todoFirestore
        .doc(todo.id)
        .update({'done': todo.done})
        .then((value) => print("Todo Added"))
        .catchError((error) => print("Failed to add Todo: $error"));
  }

  Future<QuerySnapshot> getTodos(String userId) async {
    //should return list of todomodels.
    QuerySnapshot res =
        await _todoFirestore.where('userId', isEqualTo: userId).get();

    return res;
  }

  Stream<QuerySnapshot> changesOnTodo(String userId) =>
      _todoFirestore.where('userId', isEqualTo: userId).snapshots();
}
