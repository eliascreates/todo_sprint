import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:todo_sprint/core/error/exceptions.dart';
import 'package:todo_sprint/features/todo/data/models/todo_model.dart';

/// Interface for the todo remote data source.
abstract class TodoRemoteDataSource {
  /// Retrieves all todos from the remote data source.
  /// Calls the https://api.nstack.in/v1/todos?page=1&limit=10 endpoint.
  ///
  /// Returns a [Future] that completes with a [List] of [TodoModel] objects.
  /// Throws a [ServerException] if the API call fails.
  Future<List<TodoModel>> getAllTodos();

  /// Retrieves a specific todo by its ID from the remote data source.
  /// Calls the https://api.nstack.in/v1/todos endpoint.
  ///
  /// [todoId] represents the unique ID of the todo to retrieve.
  /// Returns a [Future] that completes with the corresponding [TodoModel] object.
  /// Throws a [ServerException] if the API call fails.
  /// Throws a [NotFoundException] if the todo with the given ID is not found.
  Future<TodoModel> getTodoById(String todoId);

  /// Creates a new todo and saves it to the remote data source.
  /// Calls the https://api.nstack.in/v1/todos endpoint.
  ///
  /// [TodoModel] represents the todo to be created.
  /// Returns a [Future] that completes with [TodoModel] when the operation is successful.
  /// Throws a [ServerException] if the API call fails.
  Future<TodoModel> createTodo(TodoModel todo);

  /// Updates an existing todo and persists the changes to the remote data source.
  /// Calls the https://api.nstack.in/v1/todos endpoint.
  ///
  /// [todo] represents the todo with updated details.
  /// Returns a [Future] that completes with [TodoModel] when the operation is successful.
  /// Throws a [ServerException] if the API call fails.
  /// Throws a [NotFoundException] if the todo with the given ID is not found.
  Future<TodoModel> updateTodo(TodoModel todo);

  /// Deletes a specific todo from the remote data source.
  /// Calls the https://api.nstack.in/v1/todos/{todoId} endpoint.
  ///
  /// [todoId] represents the unique ID of the todo to delete.
  /// Returns a [Future] that completes with [String] when the operation is successful.
  /// Throws a [ServerException] if the API call fails.
  /// Throws a [NotFoundException] if the todo with the given ID is not found.
  Future<String> deleteTodo(String todoId);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final http.Client client;

  const TodoRemoteDataSourceImpl({required this.client});

  @override
  Future<TodoModel> createTodo(TodoModel todo) async {
    const url = 'https://api.nstack.in/v1/todos';

    final response = await client.post(
      Uri.parse(url),
      body: jsonEncode(todo.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return TodoModel.fromJson(jsonDecode(response.body)['data']);
    }
    throw const ServerException();
  }

  @override
  Future<String> deleteTodo(String todoId) async {
    final url = 'https://api.nstack.in/v1/todos/$todoId';
    final response = await client.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      return 'success';
    }
    throw const ServerException();
  }

  @override
  Future<List<TodoModel>> getAllTodos() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';

    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> mapList = jsonDecode(response.body);

      final todos = List<TodoModel>.from(
        (mapList['items'] as List<dynamic>).map<TodoModel>(
          (todo) => TodoModel.fromJson(todo as Map<String, dynamic>),
        ),
      );

      return todos;
    }

    throw const ServerException();
  }

  @override
  Future<TodoModel> getTodoById(String todoId) {
    // TODO: implement getTodoById
    throw UnimplementedError();
  }

  @override
  Future<TodoModel> updateTodo(TodoModel todo) async {
    final url = 'https://api.nstack.in/v1/todos/${todo.id}';

    final response = await client.put(
      Uri.parse(url),
      body: jsonEncode(todo.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return TodoModel.fromJson(jsonDecode(response.body)['data']);
    }

    throw const ServerException();
  }
}
