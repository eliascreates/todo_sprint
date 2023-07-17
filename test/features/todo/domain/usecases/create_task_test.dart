import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/create_task.dart';
import 'package:mockito/mockito.dart';
import 'todo_repository.mocks.dart';


// @GenerateMocks([TodoRepository])
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
        .thenAnswer((_) async => const Right(testTodo));

    //Act
    final result = await usecase(const Params(todo: testTodo));

    //Assert
    expect(result, const Right(testTodo));
    verify(mockTodoRepository.createTask(testTodo));
    verifyNoMoreInteractions(mockTodoRepository);
  });
}
