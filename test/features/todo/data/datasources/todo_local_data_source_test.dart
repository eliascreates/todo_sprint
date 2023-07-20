
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_sprint/core/error/exceptions.dart';
import 'package:todo_sprint/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:todo_sprint/features/todo/data/models/todo_model.dart';
import './todo_local_data_source_test.mocks.dart';

@GenerateMocks([HiveInterface, Box])
void main() {
  late MockHiveInterface mockHive;
  late TodoLocalDataSource dataSource;
  late MockBox<TodoModel> mockBox;
  setUp(() {
    mockHive = MockHiveInterface();
    dataSource = TodoLocalDataSourceImpl(mockHive);
    mockBox = MockBox<TodoModel>();

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

    final Map<dynamic, TodoModel> todosMap = {
      for (var todo in testList) todo.id: todo
    };

    mockBox.putAll(todosMap);
  });

  group('createTodo', () {
    test('should create a new todo to the box', () async {
      var testTodo = TodoModel(
        id: '3',
        title: 'Test Todo',
        description: 'Test description',
        dateCreated: DateTime.now().toIso8601String(),
        dateUpdated: DateTime.now().toIso8601String(),
      );

      // Arrange
      when(mockHive.openBox<TodoModel>('todo_box'))
          .thenAnswer((_) => Future.value(mockBox));

      // Act
      final result = await dataSource.createTodo(testTodo);

      // Assert

      //A step to ensure the DateTime.now() does not affect the test
      testTodo = testTodo.copyWith(
        dateCreated: result.dateCreated,
        dateUpdated: result.dateCreated,
      );

      expect(result, testTodo);
      verify(mockBox.put('3', testTodo));
    });

    test('should throw a CacheException when adding a todo to the box fails',
        () async {
      final testTodo = TodoModel(
        id: '3',
        title: 'Test Todo',
        description: 'Test description',
        dateCreated: DateTime.now().toIso8601String(),
        dateUpdated: DateTime.now().toIso8601String(),
      );

      // Arrange
      when(mockHive.openBox<TodoModel>('todo_box'))
          .thenThrow(const CacheException());

      // Act
      final call = dataSource.createTodo;

      // Assert
      expect(
          () => call(testTodo), throwsA(const TypeMatcher<CacheException>()));
    });
  });
  group('getAllTodos', () {
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

    test('getAllTodos should return a list of todos', () async {
      // Arrange
      when(mockHive.openBox<TodoModel>('todo_box'))
          .thenAnswer((_) => Future.value(mockBox));
      when(mockBox.values).thenReturn(testList);

      // Act
      final result = await dataSource.getAllTodos();

      // Assert
      expect(result, testList);
    });
    test('should throw a cache error when unable to fetch list of todos', () {
      // Arrange
      when(mockHive.openBox<TodoModel>('todo_box'))
          .thenAnswer((_) => Future.value(mockBox));
      when(mockBox.values).thenThrow(const CacheException());

      //Act
      final call = dataSource.getAllTodos;

      //Assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
  group('getTodoById', () {
    test('should return a todo if it exists', () async {
      const todoId = '1';
      final testTodo = TodoModel(
        id: todoId,
        title: 'Test Todo',
        description: 'Test description',
        dateCreated: DateTime.now().toString(),
        dateUpdated: DateTime.now().toString(),
      );

      // Arrange
      when(mockHive.openBox<TodoModel>('todo_box'))
          .thenAnswer((_) => Future.value(mockBox));
      when(mockBox.get(todoId)).thenReturn(testTodo);

      // Act
      final result = await dataSource.getTodoById(todoId);

      // Assert
      expect(result, equals(testTodo));
    });

    test('should throw CacheException if todo does not exist', () {
      const todoId = 'non_existent_todo_id';

      // Arrange
      when(mockHive.openBox<TodoModel>('todo_box'))
          .thenAnswer((_) => Future.value(mockBox));
      when(mockBox.get(todoId)).thenReturn(null);

      // Act
      final call = dataSource.getTodoById;

      // Assert
      expect(() => call(todoId), throwsA(const TypeMatcher<CacheException>()));
    });
  });
  group('updateTodo', () {
    test('updateTodo should update an existing todo in the box', () async {
      const todoId = '1';
      final existingTodo = TodoModel(
        id: todoId,
        title: 'Test Todo',
        description: 'Test description',
        dateCreated: DateTime.now().toIso8601String(),
        dateUpdated: DateTime.now().toIso8601String(),
      );

      var updatedTodo = TodoModel(
        id: todoId,
        title: 'Updated Todo',
        description: 'Updated description',
        dateCreated: existingTodo.dateCreated,
        dateUpdated: DateTime.now().toIso8601String(),
      );
      // Arrange
      when(mockHive.openBox<TodoModel>('todo_box'))
          .thenAnswer((_) => Future.value(mockBox));
      when(mockBox.get(todoId)).thenReturn(existingTodo);

      // Act
      final result = await dataSource.updateTodo(updatedTodo);

      // Assert

      //A step to ensure DateTime.now() does not affect the test.
      updatedTodo = updatedTodo.copyWith(dateUpdated: result.dateUpdated);

      expect(result, updatedTodo);
      verify(mockBox.put(todoId, updatedTodo));
    });

    test('updateTodo should throw an CacheException if todo does not exist',
        () async {
      const todoId = 'non_existent_todo_id';
      final updatedTodo = TodoModel(
        id: todoId,
        title: 'Updated Todo',
        description: 'Updated description',
        dateCreated: DateTime.now().toIso8601String(),
        dateUpdated: DateTime.now().toIso8601String(),
      );

      // Arrange
      when(mockHive.openBox<TodoModel>('todo_box'))
          .thenAnswer((_) => Future.value(mockBox));
      when(mockBox.get(todoId)).thenReturn(null);
      when(mockBox.put(updatedTodo.id, updatedTodo))
          .thenThrow(const CacheException());

      final call = dataSource.updateTodo;
      // Assert
      expect(() => call(updatedTodo), throwsA(isInstanceOf<CacheException>()));
    });
  });
  group('deleteTodo', () {
    test('deleteTodo should delete an existing todo from the box', () async {
      const todoId = 'test_todo_id';

      // Arrange
      when(mockHive.openBox<TodoModel>('todo_box'))
          .thenAnswer((_) async => Future.value(mockBox));


      // Act
      final result = await dataSource.deleteTodo(todoId);

      // Assert
      expect(result, 'success');
      verify(mockBox.delete(todoId));
    });

    test('deleteTodo should throw an CacheException if todo does not exist',
        () async {
      const todoId = 'non_existent_todo_id';

      // Arrange
      when(mockHive.openBox<TodoModel>('todo_box'))
          .thenAnswer((_) async => await Future.value(mockBox));

      when(mockBox.delete(todoId)).thenThrow(const CacheException());

      //Act
      final call = dataSource.deleteTodo;

      // Call the deleteTodo method
      expect(() => call(todoId), throwsA(const TypeMatcher<CacheException>()));
    });
  });
}
