import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_sprint/features/todo/domain/usecases/delete_todo.dart';

import 'get_all_todo_test.mocks.dart';

void main() {
  late MockTodoRepository mockTodoRepository;
  late DeleteTodo usecase;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = DeleteTodo(mockTodoRepository);
  });

  String testId = '1';

  test(' should delete a todo', () async {
    //Arrange
    when(mockTodoRepository.deleteTodo(testId)).thenAnswer(
      (_) async => const Right('successfully deleted'),
    );
    //Act
    final result = await usecase(Params(todoId: testId));

    //Assert
    expect(result, const Right('successfully deleted'));
    verify(mockTodoRepository.deleteTodo(testId));
    verifyNoMoreInteractions(mockTodoRepository);
  });
}
