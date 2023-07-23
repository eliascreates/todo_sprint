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
// import 'package:bloc_test/bloc_test.dart';
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

  group('TodoCreated', () {
    const testTodo = Todo(
      id: '1',
      title: 'test title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
    );

    blocTest(
      'Should get data from the createTodo usecase ',
      build: () {
        when(mockCreateTodo(const create.Params(todo: testTodo))).thenAnswer(
          (_) async => const Right(testTodo),
        );

        return bloc;
      },
      act: (bloc) => bloc.add(const TodoCreated(todo: testTodo)),
      verify: (bloc) =>
          verify(mockCreateTodo(const create.Params(todo: testTodo))),
    );
    blocTest(
      'Should emit state status TodoStatus.[loading, success] when a new todo is created',
      build: () {
        when(mockCreateTodo(const create.Params(todo: testTodo)))
            .thenAnswer((_) async => const Right(testTodo));
        return bloc;
      },
      act: (bloc) => bloc.add(const TodoCreated(todo: testTodo)),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        const TodoState(todos: [testTodo], status: TodoStatus.success),
      ],
      verify: (bloc) =>
          verify(mockCreateTodo(const create.Params(todo: testTodo))),
    );
    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a ServerFailure is returned',
      build: () {
        when(mockGetAllTodos(const NoParams()))
            .thenAnswer((_) async => const Left(ServerFailure()));

        return bloc;
      },
      act: (bloc) => bloc.add(const TodoFetchedAll()),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        const TodoState(
          todos: [],
          status: TodoStatus.failure,
          errorMessage: serverFailureMessage,
        ),
      ],
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a CacheFailure is returned',
      build: () {
        when(mockCreateTodo(const create.Params(todo: testTodo)))
            .thenAnswer((_) async => const Left(CacheFailure()));

        return bloc;
      },
      act: (bloc) => bloc.add(const TodoCreated(todo: testTodo)),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        const TodoState(
          todos: [],
          status: TodoStatus.failure,
          errorMessage: cacheFailureMessage,
        ),
      ],
    );
  });

  group('TodoFetchedAll', () {
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
    blocTest(
      'Should get data from the getAllTodos usecase ',
      build: () {
        when(mockGetAllTodos(const NoParams())).thenAnswer(
          (_) async => const Right(testList),
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
            .thenAnswer((_) async => const Right(testList));
        return bloc;
      },
      act: (bloc) => bloc.add(const TodoFetchedAll()),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        const TodoState(todos: testList, status: TodoStatus.success),
      ],
      verify: (bloc) => verify(mockGetAllTodos(const NoParams())),
    );
    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a ServerFailure is returned',
      build: () {
        when(mockGetAllTodos(const NoParams()))
            .thenAnswer((_) async => const Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const TodoFetchedAll()),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        const TodoState(todos: [], status: TodoStatus.failure),
      ],
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
        const TodoState(todos: [], status: TodoStatus.failure),
      ],
    );
  });

  group('TodoByIdFetched', () {
    const testId = '1';
    const testTodo = Todo(
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
          (_) async => const Right(testTodo),
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
            .thenAnswer((_) async => const Right(testTodo));
        return bloc;
      },
      act: (bloc) => bloc.add(const TodoByIdFetched(todoId: testId)),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        const TodoState(todos: [testTodo], status: TodoStatus.success),
      ],
      verify: (bloc) =>
          verify(mockGetTodo(const get_todo.Params(todoId: testId))),
    );
    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a ServerFailure is returned',
      build: () {
        when(mockGetTodo(const get_todo.Params(todoId: testId)))
            .thenAnswer((_) async => const Left(ServerFailure()));

        return bloc;
      },
      act: (bloc) => bloc.add(const TodoByIdFetched(todoId: testId)),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        const TodoState(
          todos: [],
          status: TodoStatus.failure,
          errorMessage: serverFailureMessage,
        ),
      ],
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
        const TodoState(
          todos: [],
          status: TodoStatus.failure,
          errorMessage: cacheFailureMessage,
        ),
      ],
    );
  });
  group('TodoDeleted', () {
    const testId = '1';
    const testTodo = Todo(
      id: testId,
      title: 'test title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
    );

    const String response = "success";
    blocTest(
      'Should get data from the deleteTodo usecase ',
      build: () {
        when(mockDeleteTodo(const delete.Params(todoId: testId))).thenAnswer(
          (_) async => const Right(response),
        );

        return bloc;
      },
      seed: () => const TodoState(todos: [testTodo]),
      act: (bloc) => bloc.add(const TodoDeleted(todoId: testId)),
      verify: (bloc) =>
          verify(mockDeleteTodo(const delete.Params(todoId: testId))),
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, success] when a todo is deleted',
      build: () {
        when(mockDeleteTodo(const delete.Params(todoId: testId))).thenAnswer(
          (_) async => const Right(response),
        );

        return bloc;
      },
      seed: () => const TodoState(todos: [testTodo]),
      act: (bloc) => bloc.add(const TodoDeleted(todoId: testId)),
      expect: () => [
        const TodoState(todos: [testTodo], status: TodoStatus.loading),
        const TodoState(todos: [], status: TodoStatus.success),
      ],
      verify: (bloc) =>
          verify(mockDeleteTodo(const delete.Params(todoId: testId))),
    );
    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a ServerFailure is returned',
      build: () {
        when(mockDeleteTodo(const delete.Params(todoId: testId))).thenAnswer(
          (_) async => const Left(ServerFailure()),
        );

        return bloc;
      },
      seed: () => const TodoState(todos: [testTodo]),
      act: (bloc) => bloc.add(const TodoDeleted(todoId: testId)),
      expect: () => [
        const TodoState(todos: [testTodo], status: TodoStatus.loading),
        const TodoState(
          todos: [testTodo],
          status: TodoStatus.failure,
          errorMessage: serverFailureMessage,
        ),
      ],
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a CacheFailure is returned',
      build: () {
        when(mockDeleteTodo(const delete.Params(todoId: testId))).thenAnswer(
          (_) async => const Left(CacheFailure()),
        );

        return bloc;
      },
      seed: () => const TodoState(todos: [testTodo]),
      act: (bloc) => bloc.add(const TodoDeleted(todoId: testId)),
      expect: () => [
        const TodoState(todos: [testTodo], status: TodoStatus.loading),
        const TodoState(
          todos: [testTodo],
          status: TodoStatus.failure,
          errorMessage: cacheFailureMessage,
        ),
      ],
    );
  });

  group('TodoUpdated', () {
    const testOriginalTodo = Todo(
      id: '1',
      title: 'test original title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
    );
    const testUpdatedTodo = Todo(
      id: '1',
      title: 'test updated title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
    );

    blocTest(
      'Should get data from the updateTodo usecase ',
      build: () {
        when(mockUpdateTodo(const update.Params(todo: testOriginalTodo)))
            .thenAnswer(
          (_) async => const Right(testUpdatedTodo),
        );

        return bloc;
      },
      act: (bloc) => bloc.add(const TodoUpdated(todo: testOriginalTodo)),
      verify: (bloc) =>
          verify(mockUpdateTodo(const update.Params(todo: testOriginalTodo))),
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, success] when a todo is updated',
      build: () {
        when(mockUpdateTodo(const update.Params(todo: testOriginalTodo)))
            .thenAnswer(
          (_) async => const Right(testUpdatedTodo),
        );

        return bloc;
      },
      seed: () => const TodoState(todos: [testOriginalTodo]),
      act: (bloc) => bloc.add(const TodoUpdated(todo: testOriginalTodo)),
      expect: () => [
        const TodoState(todos: [testOriginalTodo], status: TodoStatus.loading),
        const TodoState(todos: [testUpdatedTodo], status: TodoStatus.success),
      ],
      verify: (bloc) =>
          mockUpdateTodo(const update.Params(todo: testOriginalTodo)),
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a ServerFailure is returned',
      build: () {
        when(mockUpdateTodo(const update.Params(todo: testOriginalTodo)))
            .thenAnswer(
          (_) async => const Left(ServerFailure()),
        );

        return bloc;
      },
      seed: () => const TodoState(todos: [testOriginalTodo]),
      act: (bloc) => bloc.add(const TodoUpdated(todo: testOriginalTodo)),
      expect: () => [
        const TodoState(todos: [testOriginalTodo], status: TodoStatus.loading),
        const TodoState(
          todos: [testOriginalTodo],
          status: TodoStatus.failure,
          errorMessage: serverFailureMessage,
        ),
      ],
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a CacheFailure is returned',
      build: () {
        when(mockUpdateTodo(const update.Params(todo: testOriginalTodo)))
            .thenAnswer(
          (_) async => const Left(CacheFailure()),
        );

        return bloc;
      },
      seed: () => const TodoState(todos: [testOriginalTodo]),
      act: (bloc) => bloc.add(const TodoUpdated(todo: testOriginalTodo)),
      expect: () => [
        const TodoState(todos: [testOriginalTodo], status: TodoStatus.loading),
        const TodoState(
          todos: [testOriginalTodo],
          status: TodoStatus.failure,
          errorMessage: cacheFailureMessage,
        ),
      ],
    );
  });
  group('TodoMarkAsCompleted', () {
    const testOriginalTodo = Todo(
      id: '1',
      title: 'test original title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
      isCompleted: false,
    );
    const testUpdatedTodo = Todo(
      id: '1',
      title: 'test updated title',
      description: 'test description',
      dateCreated: 'test dateCreated',
      dateUpdated: 'test dateUpdated',
      isCompleted: true,
    );
    blocTest(
      'Should emit state status TodoStatus.[loading, success] when a todo is set to complete',
      build: () {
        when(mockUpdateTodo(const update.Params(todo: testOriginalTodo)))
            .thenAnswer(
          (_) async => const Right(testUpdatedTodo),
        );

        return bloc;
      },
      seed: () => const TodoState(todos: [testOriginalTodo]),
      act: (bloc) =>
          bloc.add(const TodoToggleCompleted(todo: testOriginalTodo)),
      expect: () => [
        const TodoState(todos: [testOriginalTodo], status: TodoStatus.loading),
        const TodoState(todos: [testUpdatedTodo], status: TodoStatus.success),
      ],
      verify: (bloc) =>
          mockUpdateTodo(const update.Params(todo: testOriginalTodo)),
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a ServerFailure is returned',
      build: () {
        when(mockUpdateTodo(const update.Params(todo: testOriginalTodo)))
            .thenAnswer(
          (_) async => const Left(ServerFailure()),
        );

        return bloc;
      },
      seed: () => const TodoState(todos: [testOriginalTodo]),
      act: (bloc) =>
          bloc.add(const TodoToggleCompleted(todo: testOriginalTodo)),
      expect: () => [
        const TodoState(todos: [testOriginalTodo], status: TodoStatus.loading),
        const TodoState(
          todos: [testOriginalTodo],
          status: TodoStatus.failure,
          errorMessage: serverFailureMessage,
        ),
      ],
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a CacheFailure is returned',
      build: () {
        when(mockUpdateTodo(const update.Params(todo: testOriginalTodo)))
            .thenAnswer(
          (_) async => const Left(CacheFailure()),
        );

        return bloc;
      },
      seed: () => const TodoState(todos: [testOriginalTodo]),
      act: (bloc) =>
          bloc.add(const TodoToggleCompleted(todo: testOriginalTodo)),
      expect: () => [
        const TodoState(todos: [testOriginalTodo], status: TodoStatus.loading),
        const TodoState(
          todos: [testOriginalTodo],
          status: TodoStatus.failure,
          errorMessage: cacheFailureMessage,
        ),
      ],
    );
  });

  group('TodoClearCompleted', () {
    // Provide an initial state with a list of todos, some of which are completed
    const List<Todo> testList = [
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

    const List<Todo> testClearList = [
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
      seed: () => const TodoState(todos: testList),
      act: (bloc) => bloc.add(const TodoClearCompleted()),
      expect: () => [
        const TodoState(todos: testList, status: TodoStatus.loading),
        const TodoState(todos: testClearList, status: TodoStatus.success),
      ],
    );
  });
}
