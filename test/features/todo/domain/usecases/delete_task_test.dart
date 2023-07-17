import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_sprint/features/todo/domain/usecases/delete_task.dart';

import 'todo_repository.mocks.dart';

void main() {
  late MockTodoRepository mockTodoRepository;
  late DeleteTask usecase;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = DeleteTask(mockTodoRepository);
  });

  String testId = '1';

  test(' should delete task', () async {
    //Arrange
    when(mockTodoRepository.deleteTask(testId)).thenAnswer(
      (_) async => const Right('successfully deleted'),
    );
    //Act
    final result = await usecase(Params(todoId: testId));

    //Assert
    expect(result, const Right('successfully deleted'));
    verify(mockTodoRepository.deleteTask(testId));
    verifyNoMoreInteractions(mockTodoRepository);
  });
}
