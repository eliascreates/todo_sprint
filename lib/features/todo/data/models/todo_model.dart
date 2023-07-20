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

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? dateCreated,
    String? dateUpdated,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateCreated,
    );
  }

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
