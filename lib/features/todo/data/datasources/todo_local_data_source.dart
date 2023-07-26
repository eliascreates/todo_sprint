// import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:todo_sprint/core/error/exceptions.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/todo.dart';

/// Interface for the todo local data source.
abstract class TodoLocalDataSource {
  /// Retrieves all todos from the local data source.
  ///
  /// Returns a [List] of [Todo] objects.
  ///
  /// Throws a [CacheException] if the operation fails.
  Future<List<Todo>> getAllTodos();

  /// Retrieves a specific todo by its ID from the local data source.
  ///
  /// [todoId] represents the unique ID of the todo to retrieve.
  /// Returns the corresponding [Todo] object.
  ///
  /// Throws a [CacheException] if the operation fails.
  Future<Todo> getTodoById(String todoId);

  /// Creates a new todo and saves it to the local data source.
  ///
  /// [Todo] represents the todo to be created.
  ///
  /// Throws a [CacheException] if the operation fails.
  Future<Todo> createTodo({required String title, required String description});

  /// Updates an existing todo and persists the changes to the local data source.
  ///
  /// [Todo] represents the todo with updated details.
  ///
  /// Throws a [CacheException] if the operation fails.
  Future<Todo> updateTodo(String todoId,
      {String? title, String? description, bool? isComplete});

  /// Deletes a specific todo from the local data source.
  ///
  /// [todoId] represents the unique ID of the todo to delete.
  ///
  /// Throws a [CacheException] if the operation fails.
  Future<String> deleteTodo(String todoId);
}

const String _todoBoxName = 'todo_box';

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final HiveInterface hive;

  late Box<Todo> box;

  TodoLocalDataSourceImpl(this.hive) {
    box = hive.box<Todo>(_todoBoxName);
  }

  @override
  Future<Todo> createTodo({
    required String title,
    required String description,
  }) async {
    final newTodo = Todo(
      id: const Uuid().v1(),
      title: title,
      description: description,
      dateCreated: DateTime.now().toIso8601String(),
      dateUpdated: DateTime.now().toIso8601String(),
      isCompleted: false,
    );

    try {
      await box.put(newTodo.id, newTodo);

      return newTodo;
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<String> deleteTodo(String todoId) async {
    try {
      final todo = box.get(todoId);
      if (todo == null) throw const CacheException();

      await box.delete(todoId);
      return Future.value('success');
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<List<Todo>> getAllTodos() async {
    try {
      final todos = box.values.toList();

      return Future.value(todos);
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<Todo> getTodoById(String todoId) async {
    try {
      final todo = box.get(todoId);
      if (todo == null) throw const CacheException();

      return Future.value(todo);
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<Todo> updateTodo(String todoId,
      {String? title, String? description, bool? isComplete}) async {
    try {
      final todo = box.get(todoId);

      if (todo == null) throw const CacheException();

      final updatedTodo = todo.copyWith(
        title: title ?? todo.title,
        description: description ?? todo.description,
        isCompleted: isComplete ?? todo.isCompleted,
        dateUpdated: DateTime.now().toIso8601String(),
      );

      // Saves the updated Todo back to the box
      await box.put(todoId, updatedTodo);

      return Future.value(updatedTodo);
    } catch (e) {
      throw const CacheException();
    }
  }
}
