import 'package:todo_sprint/features/todo/domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.dateCreated,
    required super.dateUpdated,
  });

  factory TodoModel.fromJson(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dateCreated: map['dateCreated'],
      dateUpdated: map['dateUpdated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateCreated': dateCreated,
      'dateUpdated': dateUpdated,
    };
  }
}
