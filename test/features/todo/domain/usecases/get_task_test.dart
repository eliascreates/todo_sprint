import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/get_task.dart';

import 'todo_repository.mocks.dart';

void main() {
  late MockTodoRepository mockTodoRepository;
  late GetTask usecase;

  setUp(() {
    mockTodoRepository = MockTodoRepository();

    usecase = GetTask(mockTodoRepository);
  });

  const String testId = '1';

  const testTodo = Todo(
    id: '1',
    title: 'test title',
    description: 'test description',
    dateCreated: 'test dateCreated',
    dateUpdated: 'test dateUpdated',
  );

  test('should get a single task', () async {
    //Arrange
    when(mockTodoRepository.getTaskById(testId)).thenAnswer(
      (_) async => const Right(testTodo),
    );

    //Act
    final result = await usecase(const Params(todoId: testId));

    //Assert
    expect(result, const Right(testTodo));
    verify(mockTodoRepository.getTaskById(testId));
    verifyNoMoreInteractions(mockTodoRepository);
  });
}
