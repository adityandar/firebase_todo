class TodoModel {
  String? id;
  String userId;
  String title;
  bool done;

  TodoModel({
    this.id,
    required this.userId,
    required this.done,
    required this.title,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json["id"] ?? "",
      userId: json["userId"],
      done: json["done"],
      title: json["title"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'userId': userId,
      'title': title,
      'done': done,
    };
  }
}
