import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/create_task.dart';
import 'package:mockito/mockito.dart';
import 'get_tasks_test.mocks.dart';

void main() {
  late MockTodoRepository mockTodoRepository;
  late CreateTask usecase;

  setUp(() {
    mockTodoRepository = MockTodoRepository();

    usecase = CreateTask(mockTodoRepository);
  });

  const testTodo = Todo(
      id: '1',
      title: 'test title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated');
  test('should create a new task', () async {
    //Arrange
    when(mockTodoRepository.createTask(testTodo))
        .thenAnswer((_) async => const Right(null));

    //Act
    final result = await usecase(const Params(todo: testTodo));

    //Assert
    expect(result, const Right(null));
    verify(mockTodoRepository.createTask(testTodo));
    verifyNoMoreInteractions(mockTodoRepository);
  });
}
