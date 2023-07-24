import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:todo_sprint/core/error/exceptions.dart';
import 'package:todo_sprint/features/todo/data/models/todo_model.dart';

/// Interface for the todo local data source.
abstract class TodoLocalDataSource {
  /// Retrieves all todos from the local data source.
  ///
  /// Returns a [List] of [TodoModel] objects.
  ///
  /// Throws a [CacheException] if the operation fails.
  Future<List<TodoModel>> getAllTodos();

  /// Retrieves a specific todo by its ID from the local data source.
  ///
  /// [todoId] represents the unique ID of the todo to retrieve.
  /// Returns the corresponding [TodoModel] object.
  ///
  /// Throws a [CacheException] if the operation fails.
  Future<TodoModel> getTodoById(String todoId);

  /// Creates a new todo and saves it to the local data source.
  ///
  /// [TodoModel] represents the todo to be created.
  ///
  /// Throws a [CacheException] if the operation fails.
  Future<TodoModel> createTodo(TodoModel todo);

  /// Updates an existing todo and persists the changes to the local data source.
  ///
  /// [TodoModel] represents the todo with updated details.
  ///
  /// Throws a [CacheException] if the operation fails.
  Future<TodoModel> updateTodo(TodoModel todo);

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

  TodoLocalDataSourceImpl(this.hive);

  @override
  Future<TodoModel> createTodo(TodoModel todo) async {
    todo = todo.copyWith(
      dateCreated: DateTime.now().toIso8601String(),
      dateUpdated: DateTime.now().toIso8601String(),
    );

    try {
      final box = await hive.openBox<TodoModel>(_todoBoxName);
      await box.put(todo.id, todo);
      debugPrint("CREATED: $todo");
      return todo;
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<String> deleteTodo(String todoId) async {
    try {
      final box = await hive.openBox<TodoModel>(_todoBoxName);
      box.delete(todoId);

      return 'success';
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<List<TodoModel>> getAllTodos() async {
    try {
      final box = await hive.openBox<TodoModel>(_todoBoxName);
      debugPrint(box.values.toList().toString());
      return box.values.toList();
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<TodoModel> getTodoById(String todoId) async {
    try {
      final box = await hive.openBox<TodoModel>(_todoBoxName);

      final todo = box.get(todoId);

      if (todo == null) throw const CacheException();

      return todo;
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<TodoModel> updateTodo(TodoModel todo) async {
    try {
      final box = await hive.openBox<TodoModel>(_todoBoxName);

      final existingTodo = box.get(todo.id);

      final TodoModel updatedTodo = existingTodo!.copyWith(
        title: todo.title,
        description: todo.description,
        isCompleted: todo.isCompleted,
        dateUpdated: DateTime.now().toIso8601String(),
      );

      await box.put(updatedTodo.id, updatedTodo);

      return updatedTodo;
    } catch (e) {
      throw const CacheException();
    }
  }
}
