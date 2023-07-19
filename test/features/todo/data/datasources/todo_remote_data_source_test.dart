import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:todo_sprint/core/error/exceptions.dart';
import 'package:todo_sprint/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:todo_sprint/features/todo/data/models/todo_model.dart';
import '../../../../fixtures/fixture_reader.dart';
import './todo_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late TodoRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = TodoRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('createTodo', () {
    const url = 'https://api.nstack.in/v1/todos';

    const testTodo = TodoModel(
      id: '1',
      title: 'test title',
      description: 'test description',
      dateCreated: '2023-07-19T12:26:51.135Z',
      dateUpdated: '2023-07-19T12:26:51.135Z',
    );

    test(
        'should perform a POST request to create a [TodoModel] object and application/json header',
        () {
      //Arrange
      when(mockHttpClient.post(
        Uri.parse(url),
        body: jsonEncode(testTodo.toJson()),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer(
        (_) async => http.Response(fixture('create_todo_response.json'), 201),
      );

      //Act
      dataSource.createTodo(testTodo);

      //Assert
      verify(mockHttpClient.post(Uri.parse(url),
          body: jsonEncode(testTodo.toJson()),
          headers: {'Content-Type': 'application/json'}));
    });

    test(
        'should return a valid [TodoModel] when the status code is 201 (success)',
        () async {
      //Arrange
      when(mockHttpClient.post(
        Uri.parse(url),
        body: jsonEncode(testTodo.toJson()),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer(
        (_) async => http.Response(fixture('create_todo_response.json'), 201),
      );

      //Act
      final result = await dataSource.createTodo(testTodo);

      //Assert
      expect(result, testTodo);
    });

    test('should throw a ServerException when the status code is 400 (failure)',
        () async {
      //Arrange
      when(mockHttpClient.post(
        Uri.parse(url),
        body: jsonEncode(testTodo.toJson()),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer(
        (_) async => http.Response('Bad Request Exception', 400),
      );

      //Act
      final call = dataSource.createTodo;

      //Assert
      expect(
        () => call(testTodo),
        throwsA(const TypeMatcher<ServerException>()),
      );
    });
  });

  group('getAllTodos', () {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';

    const List<TodoModel> testList = [
      TodoModel(
        id: '1',
        title: 'test title',
        description: 'test description',
        dateCreated: '2023-07-19T12:26:51.135Z',
        dateUpdated: '2023-07-19T12:26:51.135Z',
      ),
      TodoModel(
        id: '2',
        title: 'test title',
        description: 'test description',
        dateCreated: '2023-07-19T12:56:14.456Z',
        dateUpdated: '2023-07-19T12:56:14.456Z',
      )
    ];

    test('should perform a GET request to get a list of Todos', () async {
      //Arrange
      when(mockHttpClient.get(Uri.parse(url))).thenAnswer((_) async =>
          http.Response(fixture('get_todo_list_response.json'), 200));

      //Act
      await dataSource.getAllTodos();

      //Assert
      verify(mockHttpClient.get(Uri.parse(url)));
    });

    test(
        'should return a valid [List] of [TodoModel] when the status code 200 (successs)',
        () async {
      //Arrange
      when(mockHttpClient.get(Uri.parse(url))).thenAnswer((_) async =>
          http.Response(fixture('get_todo_list_response.json'), 200));

      //Act
      final result = await dataSource.getAllTodos();

      //Assert
      expect(result, testList);
    });

    test('should throw a ServerException when the status code 400 (failure)',
        () {
      //Arrange
      when(mockHttpClient.get(Uri.parse(url)))
          .thenAnswer((_) async => http.Response('Bad Request Exception', 400));

      //Act
      final call = dataSource.getAllTodos;

      //Assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getTodoById ', () {});
  group('deleteTodo', () {
    const testId = '1';

    const url = 'https://api.nstack.in/v1/todos/$testId';

    test('should perform a DELETE request to delete a todo item', () async {
      //Arrange
      when(mockHttpClient.delete(Uri.parse(url))).thenAnswer(
        (_) async => http.Response('success', 200),
      );

      //Act
      await dataSource.deleteTodo(testId);

      //Assert
      verify(mockHttpClient.delete(Uri.parse(url)));
    });
    test('should return [success] when the status code is 200 (success)',
        () async {
      //Arrange
      when(mockHttpClient.delete(Uri.parse(url))).thenAnswer(
        (_) async => http.Response(fixture('delete_todo_response.json'), 200),
      );

      //Act
      final result = await dataSource.deleteTodo(testId);

      //Assert
      expect(result, 'success');
    });
    test('should throw a ServerException when the status code is 400 (failure)',
        () async {
      //Arrange
      when(mockHttpClient.delete(Uri.parse(url))).thenAnswer(
        (_) async => http.Response('Bad Request Exception', 400),
      );

      //Act
      final call = dataSource.deleteTodo;

      //Assert
      expect(() => call(testId), throwsA(const TypeMatcher<ServerException>()));
    });
  });
  group('updateTodo', () {
    const testOriginalTodo = TodoModel(
      id: '1',
      title: 'test original title',
      description: 'test description',
      dateCreated: '2023-07-19T12:26:51.135Z',
      dateUpdated: '2023-07-19T14:26:53.726Z',
    );

    final url = 'https://api.nstack.in/v1/todos/${testOriginalTodo.id}';
    const testUpdatedTodo = TodoModel(
      id: '1',
      title: 'test updated title',
      description: 'test description',
      dateCreated: '2023-07-19T12:26:51.135Z',
      dateUpdated: '2023-07-19T15:26:53.726Z',
    );

    test('should perform a PUT request to update a todo item', () async {
      //Arrange
      when(mockHttpClient.put(
        Uri.parse(url),
        body: jsonEncode(testOriginalTodo.toJson()),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async =>
          http.Response(fixture('update_todo_response.json'), 200));

      //Act
      await dataSource.updateTodo(testOriginalTodo);

      //Assert
      verify(mockHttpClient.put(
        Uri.parse(url),
        body: jsonEncode(testOriginalTodo.toJson()),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test(
        'should return a valid updated [TodoModel] when status code is 200 (success)',
        () async {
      //Arrange
      when(mockHttpClient.put(
        Uri.parse(url),
        body: jsonEncode(testOriginalTodo.toJson()),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async =>
          http.Response(fixture('update_todo_response.json'), 200));

      //Act
      final result = await dataSource.updateTodo(testOriginalTodo);

      //Assert
      expect(result, testUpdatedTodo);
    });

    test('should throw a ServerException when status code is 400 (failure)',
        () {
      //Arrange
      when(mockHttpClient.put(
        Uri.parse(url),
        body: jsonEncode(testOriginalTodo.toJson()),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response('Bad Request Exception', 400));

      //Act
      final call = dataSource.updateTodo;

      //Assert
      expect(() => call(testOriginalTodo),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
