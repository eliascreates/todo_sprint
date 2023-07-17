
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
  Future<void> createTodo(TodoModel todo);
  
  /// Updates an existing todo and persists the changes to the local data source.
  ///
  /// [TodoModel] represents the todo with updated details.
  ///
  /// Throws a [CacheException] if the operation fails.
  Future<void> updateTodo(TodoModel todo);
  
  /// Deletes a specific todo from the local data source.
  ///
  /// [todoId] represents the unique ID of the todo to delete.
  ///
  /// Throws a [CacheException] if the operation fails.
  Future<void> deleteTodo(String todoId);
}
