import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  String dateCreated;

  @HiveField(5)
  String dateUpdated;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.dateCreated,
    required this.dateUpdated,
    this.isCompleted = false,
  });

  String formatDate(String date) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.parse(date);

    int differenceInDays = now.difference(dateTime).inDays.abs();

    if (differenceInDays == 0) {
      return 'Today - ${DateFormat('h:mm a').format(dateTime)}';
    } else if (differenceInDays == 1) {
      return 'Yesterday - ${DateFormat('h:mm a').format(dateTime)}';
    } else if (differenceInDays <= 7) {
      return '$differenceInDays days ago';
    } else {
      return DateFormat('MMM d, y, h:mm a').format(dateTime);
    }
  }

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? dateCreated,
    String? dateUpdated,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateCreated,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> map) {
    return Todo(
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

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, description: $description, '
        'isCompleted: $isCompleted, dateCreated: $dateCreated, dateUpdated: $dateUpdated)';
  }

  @override
  bool operator ==(covariant Todo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.isCompleted == isCompleted &&
        other.dateCreated == dateCreated &&
        other.dateUpdated == dateUpdated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        isCompleted.hashCode ^
        dateCreated.hashCode ^
        dateUpdated.hashCode;
  }
}