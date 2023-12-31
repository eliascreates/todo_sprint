import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/get_todo.dart';

import 'get_all_todo_test.mocks.dart';


void main() {
  late MockTodoRepository mockTodoRepository;
  late GetTodo usecase;

  setUp(() {
    mockTodoRepository = MockTodoRepository();

    usecase = GetTodo(mockTodoRepository);
  });

  const String testId = '1';

  final testTodo = Todo(
    id: '1',
    title: 'test title',
    description: 'test description',
    dateCreated: 'test dateCreated',
    dateUpdated: 'test dateUpdated',
  );

  test('should get a single todo', () async {
    //Arrange
    when(mockTodoRepository.getTodoById(testId)).thenAnswer(
      (_) async => Right(testTodo),
    );

    //Act
    final result = await usecase(const Params(todoId: testId));

    //Assert
    expect(result,  Right(testTodo));
    verify(mockTodoRepository.getTodoById(testId));
    verifyNoMoreInteractions(mockTodoRepository);
  });
}
