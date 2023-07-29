import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/create_todo.dart';
import 'package:mockito/mockito.dart';
import 'get_all_todo_test.mocks.dart';

void main() {
  late MockTodoRepository mockTodoRepository;
  late CreateTodo usecase;

  setUp(() {
    mockTodoRepository = MockTodoRepository();

    usecase = CreateTodo(mockTodoRepository);
  });

  final testTodo = Todo(
      id: '1',
      title: 'test title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated');
  test('should create a new todo', () async {
    //Arrange
    when(mockTodoRepository.createTodo(title: testTodo.title, description: testTodo.description))
        .thenAnswer((_) async => Right(testTodo));

    //Act
    final result = await usecase(Params(title: testTodo.title, description: testTodo.description));

    //Assert
    expect(result, Right(testTodo));
    verify(mockTodoRepository.createTodo(title: testTodo.title, description: testTodo.description));
    verifyNoMoreInteractions(mockTodoRepository);
  });
}
