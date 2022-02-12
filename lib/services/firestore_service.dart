import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo/model/todo_model.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addTodo(TodoModel todo) {
    CollectionReference todos = FirebaseFirestore.instance.collection('todos');

    todos
        .add(todo.toJson())
        .then((value) => print("Todo Added"))
        .catchError((error) => print("Failed to add Todo: $error"));
  }
}
