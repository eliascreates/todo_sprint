import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_sprint/core/usecases/usecase.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo_sprint/features/todo/domain/usecases/get_all_todo.dart';
import 'package:mockito/mockito.dart';
import 'get_all_todo_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  late MockTodoRepository mockTodoRepository;
  late GetAllTodos usecase;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = GetAllTodos(mockTodoRepository);
  });

  List<Todo> testList = [
    Todo(
      id: '1',
      title: 'test title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
    ),
    Todo(
      id: '2',
      title: 'test title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
    )
  ];

  test('should get all todos', () async {
    //Arrange
    when(mockTodoRepository.getAllTodos()).thenAnswer(
      (_) async => Right(testList),
    );
    //Act

    final result = await usecase(const NoParams());

    //Assert
    expect(result, Right(testList));
    verify(mockTodoRepository.getAllTodos());
    verifyNoMoreInteractions(mockTodoRepository);
  });
}
