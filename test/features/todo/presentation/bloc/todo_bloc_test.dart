import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_sprint/core/error/failures.dart';
import 'package:todo_sprint/core/usecases/usecase.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/create_todo.dart'
    as create;
import 'package:todo_sprint/features/todo/domain/usecases/delete_todo.dart'
    as delete;
import 'package:todo_sprint/features/todo/domain/usecases/get_all_todo.dart'
    as get_all;
import 'package:todo_sprint/features/todo/domain/usecases/get_todo.dart'
    as get_todo;
import 'package:todo_sprint/features/todo/domain/usecases/update_todo.dart'
    as update;
import 'package:todo_sprint/features/todo/presentation/bloc/todo_bloc.dart';
import 'todo_bloc_test.mocks.dart';

@GenerateMocks([
  create.CreateTodo,
  get_all.GetAllTodos,
  get_todo.GetTodo,
  update.UpdateTodo,
  delete.DeleteTodo
])
void main() {
  late TodoBloc bloc;
  late MockCreateTodo mockCreateTodo;
  late MockGetAllTodos mockGetAllTodos;
  late MockGetTodo mockGetTodo;
  late MockUpdateTodo mockUpdateTodo;
  late MockDeleteTodo mockDeleteTodo;

  setUp(() {
    mockCreateTodo = MockCreateTodo();
    mockGetAllTodos = MockGetAllTodos();
    mockGetTodo = MockGetTodo();
    mockUpdateTodo = MockUpdateTodo();
    mockDeleteTodo = MockDeleteTodo();

    bloc = TodoBloc(
      createTodo: mockCreateTodo,
      getAllTodos: mockGetAllTodos,
      getTodo: mockGetTodo,
      updateTodo: mockUpdateTodo,
      deleteTodo: mockDeleteTodo,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is TodoStatus.initial when the bloc is instantiated', () {
    expect(bloc.state.status, equals(TodoStatus.initial));
  });

  final cacheFailureMessage = const CacheFailure().message;

  group('TodoCreated', () {
    final testTodo = Todo(
      id: '1',
      title: 'test title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
    );

    blocTest(
      'Should get data from the createTodo usecase ',
      build: () {
        when(mockCreateTodo(create.Params(
                title: testTodo.title, description: testTodo.description)))
            .thenAnswer(
          (_) async => Right(testTodo),
        );

        return bloc;
      },
      act: (bloc) => bloc.add(TodoCreated(
          title: testTodo.title, description: testTodo.description)),
      verify: (bloc) => verify(mockCreateTodo(create.Params(
          title: testTodo.title, description: testTodo.description))),
    );
    blocTest(
      'Should emit state status TodoStatus.[loading, success] when a new todo is created',
      build: () {
        when(mockCreateTodo(create.Params(
                title: testTodo.title, description: testTodo.description)))
            .thenAnswer((_) async => Right(testTodo));
        return bloc;
      },
      act: (bloc) => bloc.add(TodoCreated(
          title: testTodo.title, description: testTodo.description)),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        TodoState(todos: [testTodo], status: TodoStatus.success),
      ],
      verify: (bloc) => verify(mockCreateTodo(create.Params(
          title: testTodo.title, description: testTodo.description))),
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a CacheFailure is returned',
      build: () {
        when(mockCreateTodo(create.Params(
                title: testTodo.title, description: testTodo.description)))
            .thenAnswer((_) async => const Left(CacheFailure()));

        return bloc;
      },
      act: (bloc) => bloc.add(TodoCreated(
          title: testTodo.title, description: testTodo.description)),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        TodoState(
          todos: const [],
          status: TodoStatus.failure,
          errorMessage: cacheFailureMessage,
        ),
      ],
    );
  });

  group('TodoFetchedAll', () {
    List<Todo> testList = [
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
    blocTest(
      'Should get data from the getAllTodos usecase ',
      build: () {
        when(mockGetAllTodos(const NoParams())).thenAnswer(
          (_) async => Right(testList),
        );

        return bloc;
      },
      act: (bloc) => bloc.add(const TodoFetchedAll()),
      verify: (bloc) => verify(mockGetAllTodos(const NoParams())),
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, success] when all todos are fetched',
      build: () {
        when(mockGetAllTodos(const NoParams()))
            .thenAnswer((_) async => Right(testList));
        return bloc;
      },
      act: (bloc) => bloc.add(const TodoFetchedAll()),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        TodoState(todos: testList, status: TodoStatus.success),
      ],
      verify: (bloc) => verify(mockGetAllTodos(const NoParams())),
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a CacheFailure is returned',
      build: () {
        when(mockGetAllTodos(const NoParams()))
            .thenAnswer((_) async => const Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const TodoFetchedAll()),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        TodoState(
          todos: const [],
          status: TodoStatus.failure,
          errorMessage: cacheFailureMessage,
        ),
      ],
    );
  });

  group('TodoByIdFetched', () {
    const testId = '1';
    final testTodo = Todo(
      id: testId,
      title: 'test title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
    );

    blocTest(
      'Should get data from the getTodo usecase ',
      build: () {
        when(mockGetTodo(const get_todo.Params(todoId: testId))).thenAnswer(
          (_) async => Right(testTodo),
        );

        return bloc;
      },
      act: (bloc) => bloc.add(const TodoByIdFetched(todoId: testId)),
      verify: (bloc) =>
          verify(mockGetTodo(const get_todo.Params(todoId: testId))),
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, success] when a todo is fetched',
      build: () {
        when(mockGetTodo(const get_todo.Params(todoId: testId)))
            .thenAnswer((_) async => Right(testTodo));
        return bloc;
      },
      act: (bloc) => bloc.add(const TodoByIdFetched(todoId: testId)),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        TodoState(todos: [testTodo], status: TodoStatus.success),
      ],
      verify: (bloc) =>
          verify(mockGetTodo(const get_todo.Params(todoId: testId))),
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a CacheFailure is returned',
      build: () {
        when(mockGetTodo(const get_todo.Params(todoId: testId)))
            .thenAnswer((_) async => const Left(CacheFailure()));

        return bloc;
      },
      act: (bloc) => bloc.add(const TodoByIdFetched(todoId: testId)),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        TodoState(
          todos: const [],
          status: TodoStatus.failure,
          errorMessage: cacheFailureMessage,
        ),
      ],
    );
  });
  group('TodoDeleted', () {
    const todoId = 'test_todo_id';
    final existingTodo = Todo(
      id: todoId,
      title: 'Updated Todo',
      description: 'Updated description',
      dateCreated: DateTime.now().toIso8601String(),
      dateUpdated: DateTime.now().toIso8601String(),
    );

    const String response = 'success';
    blocTest(
      'Should get data from the deleteTodo usecase ',
      build: () {
        when(mockDeleteTodo(const delete.Params(todoId: todoId))).thenAnswer(
          (_) async => const Right(response),
        );

        return bloc;
      },
      seed: () => TodoState(todos: [existingTodo]),
      act: (bloc) => bloc.add(const TodoDeleted(todoId: todoId)),
      verify: (bloc) =>
          verify(mockDeleteTodo(const delete.Params(todoId: todoId))),
    );

    blocTest(
      'Should emit state status TodoStatus.[success] when a todo is deleted',
      build: () {
        when(mockDeleteTodo(const delete.Params(todoId: todoId))).thenAnswer(
          (_) async => const Right(response),
        );

        return bloc;
      },
      seed: () => TodoState(todos: [existingTodo]),
      act: (bloc) => bloc.add(const TodoDeleted(todoId: todoId)),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.success),
      ],
      verify: (bloc) =>
          verify(mockDeleteTodo(const delete.Params(todoId: todoId))),
    );

    blocTest(
      'Should emit state status TodoStatus.[failure] when a CacheFailure is returned',
      build: () {
        when(mockDeleteTodo(const delete.Params(todoId: todoId))).thenAnswer(
          (_) async => const Left(CacheFailure()),
        );

        return bloc;
      },
      seed: () => TodoState(todos: [existingTodo]),
      act: (bloc) => bloc.add(const TodoDeleted(todoId: todoId)),
      expect: () => [
        TodoState(
          todos: [existingTodo],
          status: TodoStatus.failure,
          errorMessage: cacheFailureMessage,
        ),
      ],
    );
  });

  group('TodoUpdated', () {
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

    blocTest(
      'Should get data from the updateTodo usecase ',
      build: () {
        when(mockUpdateTodo(update.Params(
          todoId: testOriginalTodo.id,
          title: testUpdatedTodo.title,
          description: testUpdatedTodo.description,
        ))).thenAnswer(
          (_) async => Right(testUpdatedTodo),
        );

        return bloc;
      },
      act: (bloc) => bloc.add(TodoUpdated(
        todoId: testOriginalTodo.id,
        title: testUpdatedTodo.title,
        description: testUpdatedTodo.description,
      )),
      verify: (bloc) => verify(mockUpdateTodo(update.Params(
        todoId: testOriginalTodo.id,
        title: testUpdatedTodo.title,
        description: testUpdatedTodo.description,
      ))),
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, success] when a todo is updated',
      build: () {
        when(mockUpdateTodo(update.Params(
          todoId: testOriginalTodo.id,
          title: testUpdatedTodo.title,
          description: testUpdatedTodo.description,
        ))).thenAnswer(
          (_) async => Right(testUpdatedTodo),
        );

        return bloc;
      },
      seed: () => TodoState(todos: [testOriginalTodo]),
      act: (bloc) => bloc.add(TodoUpdated(
        todoId: testOriginalTodo.id,
        title: testUpdatedTodo.title,
        description: testUpdatedTodo.description,
      )),
      expect: () => [
        TodoState(todos: [testOriginalTodo], status: TodoStatus.loading),
        TodoState(todos: [testUpdatedTodo], status: TodoStatus.success),
      ],
      verify: (bloc) => mockUpdateTodo(update.Params(
        todoId: testOriginalTodo.id,
        title: testUpdatedTodo.title,
        description: testUpdatedTodo.description,
      )),
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a CacheFailure is returned',
      build: () {
        when(mockUpdateTodo(update.Params(
          todoId: testOriginalTodo.id,
          title: testUpdatedTodo.title,
          description: testUpdatedTodo.description,
        ))).thenAnswer(
          (_) async => const Left(CacheFailure()),
        );

        return bloc;
      },
      seed: () => TodoState(todos: [testOriginalTodo]),
      act: (bloc) => bloc.add(TodoUpdated(
        todoId: testOriginalTodo.id,
        title: testUpdatedTodo.title,
        description: testUpdatedTodo.description,
      )),
      expect: () => [
        TodoState(todos: [testOriginalTodo], status: TodoStatus.loading),
        TodoState(
          todos: [testOriginalTodo],
          status: TodoStatus.failure,
          errorMessage: cacheFailureMessage,
        ),
      ],
    );
  });

  group('TodoMarkAsCompleted', () {
    final testOriginalTodo = Todo(
      id: '1',
      title: 'test original title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
      isCompleted: false,
    );
    final testUpdatedTodo = testOriginalTodo.copyWith(
      isCompleted: !testOriginalTodo.isCompleted,
    );
    blocTest(
      'Should emit state status TodoStatus.[loading, success] when a todo is set to complete',
      build: () {
        when(mockUpdateTodo(update.Params(
                todoId: testOriginalTodo.id,
                isComplete: testUpdatedTodo.isCompleted)))
            .thenAnswer(
          (_) async => Right(testUpdatedTodo),
        );

        return bloc;
      },
      seed: () => TodoState(todos: [testOriginalTodo]),
      act: (bloc) => bloc.add(TodoToggleCompleted(
        todoId: testOriginalTodo.id,
        // isComplete: testUpdatedTodo.isCompleted,
      )),
      expect: () => [
        // TodoState(todos: [testOriginalTodo], status: TodoStatus.loading),
        TodoState(todos: [testUpdatedTodo], status: TodoStatus.success),
      ],
      verify: (bloc) => mockUpdateTodo(update.Params(
        todoId: testOriginalTodo.id,
        isComplete: testUpdatedTodo.isCompleted,
      )),
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a CacheFailure is returned',
      build: () {
        when(mockUpdateTodo(update.Params(
                todoId: testOriginalTodo.id,
                isComplete: testUpdatedTodo.isCompleted)))
            .thenAnswer(
          (_) async => const Left(CacheFailure()),
        );

        return bloc;
      },
      seed: () => TodoState(todos: [testOriginalTodo]),
      act: (bloc) => bloc.add(TodoToggleCompleted(
        todoId: testOriginalTodo.id,
        // isComplete: testUpdatedTodo.isCompleted,
      )),
      expect: () => [
        // TodoState(todos: [testOriginalTodo], status: TodoStatus.loading),
        TodoState(
          todos: [testOriginalTodo],
          status: TodoStatus.failure,
          errorMessage: cacheFailureMessage,
        ),
      ],
    );
  });

  group('TodoClearCompleted', () {
    // Provide an initial state with a list of todos, some of which are completed
    List<Todo> testList = [
      Todo(
        id: '1',
        title: 'Todo 1',
        description: 'Description 1',
        dateCreated: 'test dateCreated',
        dateUpdated: 'test dateUpdated',
        isCompleted: false,
      ),
      Todo(
        id: '2',
        title: 'Todo 2',
        description: 'Description 2',
        dateCreated: 'test dateCreated',
        dateUpdated: 'test dateUpdated',
        isCompleted: true,
      ),
      Todo(
        id: '3',
        title: 'Todo 3',
        description: 'Description 3',
        dateCreated: 'test dateCreated',
        dateUpdated: 'test dateUpdated',
        isCompleted: false,
      ),
    ];

    List<Todo> testClearList = [
      Todo(
        id: '1',
        title: 'Todo 1',
        description: 'Description 1',
        dateCreated: 'test dateCreated',
        dateUpdated: 'test dateUpdated',
        isCompleted: false,
      ),
      Todo(
        id: '3',
        title: 'Todo 3',
        description: 'Description 3',
        dateCreated: 'test dateCreated',
        dateUpdated: 'test dateUpdated',
        isCompleted: false,
      ),
    ];
    blocTest(
      'should emit the correct state after clearing completed todos',
      build: () => bloc,
      seed: () => TodoState(todos: testList),
      act: (bloc) => bloc.add(const TodoClearCompleted()),
      expect: () => [
        TodoState(todos: testList, status: TodoStatus.loading),
        TodoState(todos: testClearList, status: TodoStatus.success),
      ],
    );
  });
}
