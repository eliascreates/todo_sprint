import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/update_todo.dart';
import 'get_all_todo_test.mocks.dart';

void main() {
  late MockTodoRepository mockTodoRepository;
  late UpdateTodo usecase;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = UpdateTodo(mockTodoRepository);
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

  test(' should update a todo', () async {
    //Arrange
    when(mockTodoRepository.updateTodo(testOriginalTodo)).thenAnswer(
      (_) async => const Right(testUpdatedTodo),
    );

    //Act
    final result = await usecase(const Params(todo: testOriginalTodo));

    //Assert
    expect(result, const Right(testUpdatedTodo));
    verify(mockTodoRepository.updateTodo(testOriginalTodo));
    verifyNoMoreInteractions(mockTodoRepository);
  });
}
