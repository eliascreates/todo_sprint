import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_sprint/core/error/exceptions.dart';
import 'package:todo_sprint/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:uuid/uuid.dart';
import './todo_local_data_source_test.mocks.dart';

@GenerateMocks([HiveInterface, Box])
void main() async {
  late TodoLocalDataSource dataSource;
  late MockBox<Todo> mockBox;

  const String todoBoxName = 'todo_box';

  final mockHive = MockHiveInterface();

  mockHive.registerAdapter(TodoAdapter());

  setUp(() {
    mockBox = MockBox<Todo>();

    when(mockHive.box<Todo>(todoBoxName)).thenReturn(mockBox);

    dataSource = TodoLocalDataSourceImpl(mockHive);
  });

  group('createTodo', () {
    test('should create a new todo in the box', () async {
      const title = 'Test Todo';
      const description = 'This is a test todo';

      var newTodo = Todo(
        id: const Uuid().v1(),
        title: title,
        description: description,
        dateCreated: DateTime.now().toIso8601String(),
        dateUpdated: DateTime.now().toIso8601String(),
        isCompleted: false,
      );

      //Arrange
      when(mockBox.put(newTodo.id, newTodo)).thenAnswer((_) => Future.value());

      //Act
      final result = await dataSource.createTodo(
        title: title,
        description: description,
      );

      //Assert
      //? A step to ensure the DateTime.now() And Uuid().v1() does not affect the test
      newTodo = newTodo.copyWith(
        id: result.id,
        dateCreated: result.dateCreated,
        dateUpdated: result.dateCreated,
      );

      expect(result, equals(newTodo));
    });

    test('should throw a CacheException when Box.put fails', () async {
      // Arrange
      const title = 'Test Todo';
      const description = 'This is a test todo';

      // Arrange
      when(mockBox.put(any, any)).thenThrow(const CacheException());

      // Act
      final call = dataSource.createTodo;

      //Assert
      expect(
        () => call(title: title, description: description),
        throwsA(const TypeMatcher<CacheException>()),
      );
    });
  });

  group('getAllTodos', () {
    test('should return a list of TodoModels', () async {
      // Arrange
      final todos = [
        Todo(
          id: '1',
          title: 'test title',
          description: 'test description',
          dateCreated: DateTime.now().toIso8601String(),
          dateUpdated: DateTime.now().toIso8601String(),
        ),
        Todo(
          id: '2',
          title: 'test title',
          description: 'test description',
          dateCreated: DateTime.now().toIso8601String(),
          dateUpdated: DateTime.now().toIso8601String(),
        )
      ];
      when(mockBox.values.toList()).thenReturn(todos);

      // Act
      final result = await dataSource.getAllTodos();

      // Assert
      verify(mockBox.values.toList());
      expect(result, equals(todos));
    });

    test('should throw a CacheException when Box.values.toList fails',
        () async {
      // Arrange
      when(mockBox.values.toList()).thenThrow(const CacheException());

      //Act
      final call = dataSource.getAllTodos;

      //Assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('getTodoById', () {
    test('should return a todo if it exists', () async {
      const todoId = '1';
      final testTodo = Todo(
        id: todoId,
        title: 'Test Todo',
        description: 'Test description',
        dateCreated: DateTime.now().toString(),
        dateUpdated: DateTime.now().toString(),
      );

      // Arrange
      when(mockBox.get(todoId)).thenReturn(testTodo);

      // Act
      final result = await dataSource.getTodoById(todoId);

      // Assert
      expect(result, equals(testTodo));
    });

    test(
        'getTodoById should throw a CacheException when Todo with the given id does not exist',
        () async {
      // Arrange
      const todoId = 'non_existent_todo_id';

      when(mockBox.get(todoId)).thenReturn(null);

      final call = dataSource.getTodoById;

      // Assert
      expect(() => call(todoId), throwsA(const TypeMatcher<CacheException>()));
    });

    test('should throw a CacheException when Box.get fails', () {
      const todoId = 'non_existent_todo_id';

      // Arrange
      when(mockBox.get(todoId)).thenThrow(const CacheException());

      // Act
      final call = dataSource.getTodoById;

      // Assert
      expect(() => call(todoId), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('updateTodo', () {
    const todoId = '1';
    final existingTodo = Todo(
      id: todoId,
      title: 'Test Todo',
      description: 'Test description',
      dateCreated: DateTime.now().toIso8601String(),
      dateUpdated: DateTime.now().toIso8601String(),
    );

    var updatedTodo = Todo(
      id: todoId,
      title: 'Updated Todo',
      description: 'Updated description',
      dateCreated: existingTodo.dateCreated,
      dateUpdated: DateTime.now().toIso8601String(),
    );

    test('should update an existing todo in the box', () async {
      // Arrange
      when(mockBox.get(todoId)).thenReturn(existingTodo);

      // Act
      final result = await dataSource.updateTodo(
        todoId,
        title: updatedTodo.title,
        description: updatedTodo.description,
      );

      // Assert
      //A step to ensure DateTime.now() does not affect the test.
      updatedTodo = updatedTodo.copyWith(dateUpdated: result.dateUpdated);

      expect(result, updatedTodo);
      verify(mockBox.put(todoId, updatedTodo));
    });

    test('should throw CacheException when todo does not exist', () async {
      //Arrange
      when(mockBox.get(todoId)).thenReturn(null);

      //Act
      final call = dataSource.updateTodo;

      expect(
        () => call(todoId,
            title: updatedTodo.title,
            description: updatedTodo.description,
            isComplete: updatedTodo.isCompleted),
        throwsA(const TypeMatcher<CacheException>()),
      );

      // Verify that put method was not called when todo does not exist
      verifyNever(mockBox.put(todoId, updatedTodo));
    });

    test('should throw CacheException when an error occurs', () async {
      const todoId = 'non_existent_todo_id';
      final updatedTodo = Todo(
        id: todoId,
        title: 'Updated Todo',
        description: 'Updated description',
        dateCreated: DateTime.now().toIso8601String(),
        dateUpdated: DateTime.now().toIso8601String(),
      );

      // Arrange
      when(mockBox.get(todoId)).thenThrow(const CacheException());
      when(mockBox.put(updatedTodo.id, updatedTodo))
          .thenThrow(const CacheException());

      final call = dataSource.updateTodo;
      // Assert
      expect(
          () => call(todoId,
              title: updatedTodo.title, description: updatedTodo.description),
          throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('deleteTodo', () {
    const todoId = 'test_todo_id';
    final existingTodo = Todo(
      id: todoId,
      title: 'Updated Todo',
      description: 'Updated description',
      dateCreated: DateTime.now().toIso8601String(),
      dateUpdated: DateTime.now().toIso8601String(),
    );

    test('should delete an existing todo from the box', () async {
      // Arrange
      when(mockBox.get(todoId)).thenReturn(existingTodo);
      when(mockBox.delete(todoId)).thenAnswer((_) => Future.value());

      // Act
      final result = await dataSource.deleteTodo(todoId);

      // Assert
      expect(result, 'success');
      verify(mockBox.delete(todoId));
    });

    test('should throw an CacheException when todo does not exist', () async {
      const todoId = 'non_existent_todo_id';

      //Arrange
      when(mockBox.get(todoId)).thenReturn(null);

      //Act
      final call = dataSource.deleteTodo;

      //Assert
      expect(() => call(todoId), throwsA(const TypeMatcher<CacheException>()));
    });

    test('should throw an CacheException when the box.delete fails', () async {
      const todoId = 'non_existent_todo_id';

      // Arrange
      when(mockBox.get(todoId)).thenReturn(existingTodo);

      when(mockBox.delete(todoId)).thenThrow(const CacheException());

      //Act
      final call = dataSource.deleteTodo;

      // Call the deleteTodo method
      expect(() => call(todoId), throwsA(const TypeMatcher<CacheException>()));
    });
  });
}
