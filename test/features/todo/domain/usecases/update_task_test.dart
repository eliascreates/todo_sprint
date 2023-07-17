import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/update_task.dart';
import 'todo_repository.mocks.dart';

void main() {
  late MockTodoRepository mockTodoRepository;
  late UpdateTask usecase;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = UpdateTask(mockTodoRepository);
  });

  const testOriginalTodo = Todo(
    id: '1',
    title: 'test original title',
    description: 'test description',
    dateCreated: 'test dateCreated',
    dateUpdated: 'test dateUpdated',
  );
  const testUpdatedTodo = Todo(
    id: '1',
    title: 'test updated title',
    description: 'test description',
    dateCreated: 'test dateCreated',
    dateUpdated: 'test dateUpdated',
  );

  test(' should update Todo when a property is updated', () async {
    //Arrange
    when(mockTodoRepository.updateTask(testOriginalTodo)).thenAnswer(
      (_) async => const Right(testUpdatedTodo),
    );

    //Act
    final result = await usecase(const Params(todo: testOriginalTodo));

    //Assert
    expect(result, const Right(testUpdatedTodo));
    verify(mockTodoRepository.updateTask(testOriginalTodo));
    verifyNoMoreInteractions(mockTodoRepository);
  });
}
