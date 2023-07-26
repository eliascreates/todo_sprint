import 'package:todo_sprint/core/error/exceptions.dart';
// import 'package:todo_sprint/features/todo/data/models/todo_model.dart';

import '../../domain/entities/todo.dart';

/// Interface for the todo remote data source.
//? Remote Data Source Removed Impl - If needed in the future, Implement new one
abstract class TodoRemoteDataSource {
  /// Retrieves all todos from the remote data source.
  /// Calls the https://api.nstack.in/v1/todos?page=1&limit=10 endpoint.
  ///
  /// Returns a [Future] that completes with a [List] of [Todo] objects.
  /// Throws a [ServerException] if the API call fails.
  Future<List<Todo>> getAllTodos();

  /// Retrieves a specific todo by its ID from the remote data source.
  /// Calls the https://api.nstack.in/v1/todos endpoint.
  ///
  /// [todoId] represents the unique ID of the todo to retrieve.
  /// Returns a [Future] that completes with the corresponding [Todo] object.
  /// Throws a [ServerException] if the API call fails.
  /// Throws a [NotFoundException] if the todo with the given ID is not found.
  Future<Todo> getTodoById(String todoId);

  /// Creates a new todo and saves it to the remote data source.
  /// Calls the https://api.nstack.in/v1/todos endpoint.
  ///
  /// [Todo] represents the todo to be created.
  /// Returns a [Future] that completes with [Todo] when the operation is successful.
  /// Throws a [ServerException] if the API call fails.
  Future<Todo> createTodo(Todo todo);

  /// Updates an existing todo and persists the changes to the remote data source.
  /// Calls the https://api.nstack.in/v1/todos endpoint.
  ///
  /// [todo] represents the todo with updated details.
  /// Returns a [Future] that completes with [Todo] when the operation is successful.
  /// Throws a [ServerException] if the API call fails.
  /// Throws a [NotFoundException] if the todo with the given ID is not found.
  Future<Todo> updateTodo(Todo todo);

  /// Deletes a specific todo from the remote data source.
  /// Calls the https://api.nstack.in/v1/todos/{todoId} endpoint.
  ///
  /// [todoId] represents the unique ID of the todo to delete.
  /// Returns a [Future] that completes with [String] when the operation is successful.
  /// Throws a [ServerException] if the API call fails.
  /// Throws a [NotFoundException] if the todo with the given ID is not found.
  Future<String> deleteTodo(String todoId);
}