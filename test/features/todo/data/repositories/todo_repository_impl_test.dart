import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_sprint/core/error/exceptions.dart';
import 'package:todo_sprint/core/error/failures.dart';
import 'package:todo_sprint/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:todo_sprint/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import './todo_repository_impl_test.mocks.dart';

@GenerateMocks([
  TodoLocalDataSource,
])
void main() {
  late TodoRepositoryImpl repository;

  late MockTodoLocalDataSource mockTodoLocalDataSource;
  // late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockTodoLocalDataSource = MockTodoLocalDataSource();
    // mockNetworkInfo = MockNetworkInfo();

    repository = TodoRepositoryImpl(
      localDataSource: mockTodoLocalDataSource,
      // networkInfo: mockNetworkInfo,
    );
  });

  group('Local Data Source', () {
    group('createTodo', () {
      final testTodo = Todo(
        id: '1',
        title: 'test title',
        description: 'test description',
        dateCreated: 'test dateCreated',
        dateUpdated: 'test dateUpdated',
      );
      test('should create todo when local data source is successful', () async {
        //Arrange
        when(mockTodoLocalDataSource.createTodo(
                title: testTodo.title, description: testTodo.description))
            .thenAnswer((_) async => testTodo);

        //Act
        final result = await repository.createTodo(
            title: testTodo.title, description: testTodo.description);

        //Assert
        expect(result, Right(testTodo));
        verify(mockTodoLocalDataSource.createTodo(
            title: testTodo.title, description: testTodo.description));
        verifyNoMoreInteractions(mockTodoLocalDataSource);
      });

      test(
          'should return a Cache Failure when local data source fails to creating a todo',
          () async {
        //Arrange
        when(mockTodoLocalDataSource.createTodo(
                title: testTodo.title, description: testTodo.description))
            .thenThrow(const CacheException());

        //Act
        final result = await repository.createTodo(
            title: testTodo.title, description: testTodo.description);
        //Assert
        expect(result, const Left(CacheFailure()));
        verify(mockTodoLocalDataSource.createTodo(
            title: testTodo.title, description: testTodo.description));
      });
    });

    group('getAllTodos', () {
      final List<Todo> testList = [
        Todo(
            id: '1',
            title: 'test title',
            description: 'test description',
            dateCreated: 'test dateCreated',
            dateUpdated: 'test dateUpdated'),
        Todo(
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
        expect(result, Right(testList));
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
      final testTodo = Todo(
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
        expect(result, Right(testTodo));
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
      const todoId = '1';
      const todoIsComplete = true;
      final existingTodo = Todo(
        id: todoId,
        title: 'Test Todo',
        description: 'Test description',
        dateCreated: DateTime.now().toIso8601String(),
        dateUpdated: DateTime.now().toIso8601String(),
        isCompleted: false,
      );

      var updatedTodo = Todo(
        id: todoId,
        title: existingTodo.title,
        description: existingTodo.description,
        dateCreated: existingTodo.dateCreated,
        dateUpdated: DateTime.now().toIso8601String(),
        isCompleted: todoIsComplete,
      );

      test('should update a todo when the local data source is successful',
          () async {
        //Arrange
        when(
          mockTodoLocalDataSource.updateTodo(todoId,
              isComplete: todoIsComplete),
        ).thenAnswer((_) async => updatedTodo);

        //Act
        final result =
            await repository.updateTodo(todoId, isComplete: todoIsComplete);

        //Assert
        expect(result, Right(updatedTodo));
        verify(mockTodoLocalDataSource.updateTodo(todoId,
            isComplete: todoIsComplete));
        verifyNoMoreInteractions(mockTodoLocalDataSource);
      });
      test(
          'should return a Cache Failure when the local data source is unsuccessful in updating the todo',
          () async {
        //Arrange
        when(mockTodoLocalDataSource.updateTodo(todoId,
                isComplete: todoIsComplete))
            .thenThrow(const CacheException());
        //Act
        final result =
            await repository.updateTodo(todoId, isComplete: todoIsComplete);

        //Assert
        expect(result, const Left(CacheFailure()));
        verify(mockTodoLocalDataSource.updateTodo(todoId,
            isComplete: todoIsComplete));
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