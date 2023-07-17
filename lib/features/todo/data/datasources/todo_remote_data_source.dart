import 'package:todo_sprint/features/todo/data/models/todo_model.dart';

/// Interface for the todo remote data source.
abstract class TodoRemoteDataSource {
  /// Retrieves all todos from the remote data source.
  ///
  /// Returns a [Future] that completes with a [List] of [TodoModel] objects.
  /// Throws a [ServerException] if the API call fails.
  Future<List<TodoModel>> getAllTodos();

  /// Retrieves a specific todo by its ID from the remote data source.
  ///
  /// [todoId] represents the unique ID of the todo to retrieve.
  /// Returns a [Future] that completes with the corresponding [TodoModel] object.
  /// Throws a [ServerException] if the API call fails.
  /// Throws a [NotFoundException] if the todo with the given ID is not found.
  Future<TodoModel> getTodoById(String todoId);

  /// Creates a new todo and saves it to the remote data source.
  ///
  /// [TodoModel] represents the todo to be created.
  /// Returns a [Future] that completes with [TodoModel] when the operation is successful.
  /// Throws a [ServerException] if the API call fails.
  Future<TodoModel> createTodo(TodoModel todo);

  /// Updates an existing todo and persists the changes to the remote data source.
  ///
  /// [todo] represents the todo with updated details.
  /// Returns a [Future] that completes with [TodoModel] when the operation is successful.
  /// Throws a [ServerException] if the API call fails.
  /// Throws a [NotFoundException] if the todo with the given ID is not found.
  Future<TodoModel> updateTodo(TodoModel todo);

  /// Deletes a specific todo from the remote data source.
  ///
  /// [todoId] represents the unique ID of the todo to delete.
  /// Returns a [Future] that completes with [String] when the operation is successful.
  /// Throws a [ServerException] if the API call fails.
  /// Throws a [NotFoundException] if the todo with the given ID is not found.
  Future<String> deleteTodo(String todoId);
}
