import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_sprint/core/usecases/usecase.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo_sprint/features/todo/domain/usecases/get_all_tasks.dart';
import 'package:mockito/mockito.dart';
import 'todo_repository.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  late MockTodoRepository mockTodoRepository;
  late GetTasks usecase;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = GetTasks(mockTodoRepository);
  });

  const List<Todo> testList = [
    Todo(
        id: '1',
        title: 'test title',
        description: 'test description',
        dateCreated: 'test dateCreated',
        dateUpdated: 'test dateUpdated'),
    Todo(
      id: '2',
      title: 'test title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
    )
  ];

  test('should get all tasks', () async {
    //Arrange
    when(mockTodoRepository.getAllTasks()).thenAnswer(
      (_) async => const Right(
        <Todo>[
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
          ),
        ],
      ),
    );
    //Act

    final result = await usecase(NoParams());

    //Assert
    expect(result, const Right(testList));
    verify(mockTodoRepository.getAllTasks());
    verifyNoMoreInteractions(mockTodoRepository);
  });
}
