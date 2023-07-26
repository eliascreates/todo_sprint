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

  final testOriginalTodo = Todo(
    id: '1',
    title: 'test original title',
    description: 'test description',
    dateCreated: 'test dateCreated',
    dateUpdated: 'test dateUpdated',
  );
  final testUpdatedTodo = Todo(
    id: '1',
    title: 'test updated title',
    description: 'test description',
    dateCreated: 'test dateCreated',
    dateUpdated: 'test dateUpdated',
  );

  test(' should update a todo', () async {
    //Arrange
    when(mockTodoRepository.updateTodo(
      testOriginalTodo.id,
      title: testUpdatedTodo.title,
      description: testUpdatedTodo.description,
    )).thenAnswer(
      (_) async => Right(testUpdatedTodo),
    );

    //Act
    final result = await usecase(Params(
      todoId: testOriginalTodo.id,
      title: testUpdatedTodo.title,
      description: testUpdatedTodo.description,
    ));

    //Assert
    expect(result, Right(testUpdatedTodo));
    verify(mockTodoRepository.updateTodo(
      testOriginalTodo.id,
      title: testUpdatedTodo.title,
      description: testUpdatedTodo.description,
    ));
    verifyNoMoreInteractions(mockTodoRepository);
  });
}
