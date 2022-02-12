class TodoModel {
  String title;
  bool done;

  TodoModel({
    required this.done,
    required this.title,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(done: json["done"], title: json["title"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'done': done,
    };
  }
}
