import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/create_todo.dart';
import 'package:mockito/mockito.dart';
import 'todo_repository.mocks.dart';


// @GenerateMocks([TodoRepository])
void main() {
  late MockTodoRepository mockTodoRepository;
  late CreateTodo usecase;

  setUp(() {
    mockTodoRepository = MockTodoRepository();

    usecase = CreateTodo(mockTodoRepository);
  });

  const testTodo = Todo(
      id: '1',
      title: 'test title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated');
  test('should create a new todo', () async {
    //Arrange
    when(mockTodoRepository.createTodo(testTodo))
        .thenAnswer((_) async => const Right(testTodo));

    //Act
    final result = await usecase(const Params(todo: testTodo));

    //Assert
    expect(result, const Right(testTodo));
    verify(mockTodoRepository.createTodo(testTodo));
    verifyNoMoreInteractions(mockTodoRepository);
  });
}
