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
  test('should check if the device is online', () async {
    //Arrange
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

    //Act
    await repository.networkInfo.isConnected;

    //Assert
    verify(mockNetworkInfo.isConnected);
  });

  test('should check if the device is offline', () async {
    //Arrange
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

    //Act
    await repository.networkInfo.isConnected;

    //Assert
    verify(mockNetworkInfo.isConnected);
  });

  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    group('createTodo', () {
      const testTodo = TodoModel(
        id: '1',
        title: 'test title',
        description: 'test description',
        dateCreated: 'test dateCreated',
        dateUpdated: 'test dateUpdated',
      );
      test('should create and cache todo when remote data source is successful',
          () async {
        //Arrange
        when(mockTodoRemoteDataSource.createTodo(testTodo))
            .thenAnswer((_) async => testTodo);
        when(mockTodoLocalDataSource.createTodo(testTodo))
            .thenAnswer((_) async => testTodo);

        //Act
        final result = await repository.createTodo(testTodo);
        //Assert
        expect(result, const Right(testTodo));
        verify(mockTodoRemoteDataSource.createTodo(testTodo));
        verify(mockTodoLocalDataSource.createTodo(testTodo));
        verifyNoMoreInteractions(mockTodoRemoteDataSource);
        verifyNoMoreInteractions(mockTodoLocalDataSource);
      });

      test(
          'should return a Server Failure when remote data source fails to creating a todo',
          () async {
        //Arrange
        when(mockTodoRemoteDataSource.createTodo(testTodo))
            .thenThrow(const ServerException());

        //Act
        final result = await repository.createTodo(testTodo);
        //Assert
        expect(result, const Left(ServerFailure()));
        verify(mockTodoRemoteDataSource.createTodo(testTodo));
        verifyZeroInteractions(mockTodoLocalDataSource);
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

      test(
          'should return a list of todos when remote data source is successful',
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
      test(
          'should return a specific todo when remote data source is successful',
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

      test(
          'should update a todo remotely and locally, when the remote data source is successful',
          () async {
        //Arrange
        when(mockTodoRemoteDataSource.updateTodo(testOriginalTodo))
            .thenAnswer((_) async => testUpdatedTodo);
        when(mockTodoLocalDataSource.updateTodo(testOriginalTodo))
            .thenAnswer((_) async => testUpdatedTodo);

        //Act
        final result = await repository.updateTodo(testOriginalTodo);

        //Assert
        expect(result, const Right(testUpdatedTodo));
        verify(mockTodoRemoteDataSource.updateTodo(testOriginalTodo));
        verify(mockTodoLocalDataSource.updateTodo(testOriginalTodo));
        verifyNoMoreInteractions(mockTodoRemoteDataSource);
        verifyNoMoreInteractions(mockTodoLocalDataSource);
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
        verify(mockTodoRemoteDataSource.updateTodo(testOriginalTodo));
        verifyZeroInteractions(mockTodoLocalDataSource);
      });
    });

    group('deleteTodo', () {
      const String responseString = 'successfully deleted';
      const String testId = '1';
      test(
          'should delete a todo remotely and locally, when the remote data source is successful',
          () async {
        //Arrange
        when(mockTodoRemoteDataSource.deleteTodo(testId))
            .thenAnswer((_) async => responseString);
        when(mockTodoLocalDataSource.deleteTodo(testId))
            .thenAnswer((_) async => responseString);

        //Act
        final result = await repository.deleteTodo(testId);

        //Assert
        expect(result, const Right(responseString));
        verify(mockTodoRemoteDataSource.deleteTodo(testId));
        verify(mockTodoLocalDataSource.deleteTodo(testId));
        verifyNoMoreInteractions(mockTodoRemoteDataSource);
        verifyNoMoreInteractions(mockTodoLocalDataSource);
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
        verify(mockTodoRemoteDataSource.deleteTodo(testId));
        verifyZeroInteractions(mockTodoLocalDataSource);
      });
    });
  });

  group('device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    group('createTodo', () {
      const testTodo = TodoModel(
        id: '1',
        title: 'test title',
        description: 'test description',
        dateCreated: 'test dateCreated',
        dateUpdated: 'test dateUpdated',
      );
      test('should create todo when local data source is successful', () async {
        //Arrange
        when(mockTodoLocalDataSource.createTodo(testTodo))
            .thenAnswer((_) async => testTodo);

        //Act
        final result = await repository.createTodo(testTodo);
        //Assert
        expect(result, const Right(testTodo));
        verify(mockTodoLocalDataSource.createTodo(testTodo));
        verifyNoMoreInteractions(mockTodoLocalDataSource);
      });

      test(
          'should return a Cache Failure when local data source fails to creating a todo',
          () async {
        //Arrange
        when(mockTodoLocalDataSource.createTodo(testTodo))
            .thenThrow(const CacheException());

        //Act
        final result = await repository.createTodo(testTodo);
        //Assert
        expect(result, const Left(CacheFailure()));
        verify(mockTodoLocalDataSource.createTodo(testTodo));
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

      test('should return a list of todos when local data source is successful',
          () async {
        //Arrange
        when(mockTodoLocalDataSource.getAllTodos())
            .thenAnswer((_) async => testList);

        //Act
        final result = await repository.getAllTodos();

        //Assert
        expect(result, const Right(testList));
      });
      test(
          'should return a Cache Failure when local data source is unsuccessful in getting all todos',
          () async {
        //Arrange
        when(mockTodoLocalDataSource.getAllTodos())
            .thenThrow(const CacheException());

        //Act
        final result = await repository.getAllTodos();

        //Assert
        expect(result, const Left(CacheFailure()));
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
      test('should return a specific todo when local data source is successful',
          () async {
        //Arrange
        when(mockTodoLocalDataSource.getTodoById(testId))
            .thenAnswer((_) async => testTodo);

        //Act
        final result = await repository.getTodoById(testId);

        //Assert
        expect(result, const Right(testTodo));
      });
      test(
          'should return a Cache Failure when local data source is unsuccessful in fetching a specific todo',
          () async {
        //Arrange
        when(mockTodoLocalDataSource.getTodoById(testId))
            .thenThrow(const CacheException());

        //Act
        final result = await repository.getTodoById(testId);

        //Assert
        expect(result, const Left(CacheFailure()));
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

      test('should update a todo when the local data source is successful',
          () async {
        //Arrange
        when(mockTodoLocalDataSource.updateTodo(testOriginalTodo))
            .thenAnswer((_) async => testUpdatedTodo);

        //Act
        final result = await repository.updateTodo(testOriginalTodo);

        //Assert
        expect(result, const Right(testUpdatedTodo));
        verify(mockTodoLocalDataSource.updateTodo(testOriginalTodo));
        verifyNoMoreInteractions(mockTodoLocalDataSource);
      });
      test(
          'should return a Cache Failure when the local data source is unsuccessful in updating the todo',
          () async {
        //Arrange
        when(mockTodoLocalDataSource.updateTodo(testOriginalTodo))
            .thenThrow(const CacheException());
        //Act
        final result = await repository.updateTodo(testOriginalTodo);

        //Assert
        expect(result, const Left(CacheFailure()));
        verify(mockTodoLocalDataSource.updateTodo(testOriginalTodo));
      });
    });

    group('deleteTodo', () {
      const String responseString = 'successfully deleted';
      const String testId = '1';
      test('should delete a todo when the local data source is successful',
          () async {
        //Arrange
        when(mockTodoLocalDataSource.deleteTodo(testId))
            .thenAnswer((_) async => responseString);

        //Act
        final result = await repository.deleteTodo(testId);

        //Assert
        expect(result, const Right(responseString));
        verify(mockTodoLocalDataSource.deleteTodo(testId));
        verifyNoMoreInteractions(mockTodoLocalDataSource);
      });
      test(
          'should return a Cache Failure when the local data source is unsuccessful in deleting the todo',
          () async {
        //Arrange
        when(mockTodoLocalDataSource.deleteTodo(testId))
            .thenThrow(const CacheException());

        //Act
        final result = await repository.deleteTodo(testId);

        //Assert
        expect(result, const Left(CacheFailure()));
        verify(mockTodoLocalDataSource.deleteTodo(testId));
      });
    });
  });
}
