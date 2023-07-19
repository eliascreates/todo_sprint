import 'package:todo_sprint/features/todo/domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.title,
    required super.description,
    super.isCompleted,
    required super.dateCreated,
    required super.dateUpdated,
  });

  factory TodoModel.fromJson(Map<String, dynamic> map) {
    return TodoModel(
      id: map['_id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['is_completed'],
      dateCreated: map['created_at'],
      dateUpdated: map['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
    };
  }
}
