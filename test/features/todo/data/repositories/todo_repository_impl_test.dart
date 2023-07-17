import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_sprint/core/error/exceptions.dart';
import 'package:todo_sprint/core/error/failures.dart';
import 'package:todo_sprint/core/network/network_info.dart';
import 'package:todo_sprint/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:todo_sprint/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:todo_sprint/features/todo/data/models/todo_model.dart';
import 'package:todo_sprint/features/todo/data/repositories/todo_repository_impl.dart';
import './todo_repository_impl_test.mocks.dart';

@GenerateMocks([
  TodoLocalDataSource,
  TodoRemoteDataSource,
  NetworkInfo,
])
void main() {
  late TodoRepositoryImpl repository;

  late MockTodoLocalDataSource mockTodoLocalDataSource;
  late MockTodoRemoteDataSource mockTodoRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockTodoLocalDataSource = MockTodoLocalDataSource();
    mockTodoRemoteDataSource = MockTodoRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = TodoRepositoryImpl(
      localDataSource: mockTodoLocalDataSource,
      remoteDataSource: mockTodoRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('createTodo', () {
    const testTodo = TodoModel(
      id: '1',
      title: 'test title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
    );

    test(
        'should return a todo when remote data source is successful at creating a todo',
        () async {
      //Arrange
      when(mockTodoRemoteDataSource.createTodo(testTodo))
          .thenAnswer((_) async => testTodo);

      //Act
      final result = await repository.createTodo(testTodo);
      //Assert
      expect(result, const Right(testTodo));
      verify(mockTodoRemoteDataSource.createTodo(testTodo));
    });

    test(
        'should return a Server Failure when remote data source is fails to creating a todo',
        () async {
      //Arrange
      when(mockTodoRemoteDataSource.createTodo(testTodo))
          .thenThrow(const ServerException());

      //Act
      final result = await repository.createTodo(testTodo);
      //Assert
      expect(result, const Left(ServerFailure()));
      verify(mockTodoRemoteDataSource.createTodo(testTodo));
    });
  });

  group('getAllTodos', () {
    const List<TodoModel> testList = [
      TodoModel(
          id: '1',
          title: 'test title',
          description: 'test description',
          dateCreated: 'test dateCreated',
          dateUpdated: 'test dateUpdated'),
      TodoModel(
        id: '2',
        title: 'test title',
        description: 'test description',
        dateCreated: 'test dateCreated',
        dateUpdated: 'test dateUpdated',
      )
    ];

    test('should return a list of todos when remote data source is successful',
        () async {
      //Arrange
      when(mockTodoRemoteDataSource.getAllTodos())
          .thenAnswer((_) async => testList);

      //Act
      final result = await repository.getAllTodos();

      //Assert
      expect(result, const Right(testList));
    });
    test(
        'should return a Server Failure when remote data source is unsuccessful in getting all todos',
        () async {
      //Arrange
      when(mockTodoRemoteDataSource.getAllTodos())
          .thenThrow(const ServerException());

      //Act
      final result = await repository.getAllTodos();

      //Assert
      expect(result, const Left(ServerFailure()));
    });
  });

  group('getTodoById', () {
    const testTodo = TodoModel(
      id: '1',
      title: 'test title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
    );
    const String testId = '1';
    test('should return a specific todo when remote data source is successful',
        () async {
      //Arrange
      when(mockTodoRemoteDataSource.getTodoById(testId))
          .thenAnswer((_) async => testTodo);

      //Act
      final result = await repository.getTodoById(testId);

      //Assert
      expect(result, const Right(testTodo));
    });
    test(
        'should return a Server Failure when remote data source is unsuccessful in fetching a specific todo',
        () async {
      //Arrange
      when(mockTodoRemoteDataSource.getTodoById(testId))
          .thenThrow(const ServerException());

      //Act
      final result = await repository.getTodoById(testId);

      //Assert
      expect(result, const Left(ServerFailure()));
    });
  });
  group('updateTodo', () {
    const testOriginalTodo = TodoModel(
      id: '1',
      title: 'test original title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
    );
    const testUpdatedTodo = TodoModel(
      id: '1',
      title: 'test updated title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
    );

    test('should return a update when the remote data source is successful',
        () async {
      //Arrange
      when(mockTodoRemoteDataSource.updateTodo(testOriginalTodo))
          .thenAnswer((_) async => testUpdatedTodo);
      //Act
      final result = await repository.updateTodo(testOriginalTodo);

      //Assert
      expect(result, const Right(testUpdatedTodo));
    });
    test(
        'should return a Server Failure when the remote data source is unsuccessful in updating the todo',
        () async {
      //Arrange
      when(mockTodoRemoteDataSource.updateTodo(testOriginalTodo))
          .thenThrow(const ServerException());
      //Act
      final result = await repository.updateTodo(testOriginalTodo);

      //Assert
      expect(result, const Left(ServerFailure()));
    });
  });
  group('deleteTodo', () {
    const String responseString = 'successfully deleted';
    const String testId = '1';
    test('should delete a todo when the remote data source is successful',
        () async {
      //Arrange
      when(mockTodoRemoteDataSource.deleteTodo(testId))
          .thenAnswer((_) async => responseString);

      //Act
      final result = await repository.deleteTodo(testId);

      //Assert
      expect(result, const Right(responseString));
    });
    test(
        'should return a Server Failure when the remote data source is unsuccessful in deleting the todo',
        () async {
      //Arrange
      when(mockTodoRemoteDataSource.deleteTodo(testId))
          .thenThrow(const ServerException());

      //Act
      final result = await repository.deleteTodo(testId);

      //Assert
      expect(result, const Left(ServerFailure()));
    });
  });
}
