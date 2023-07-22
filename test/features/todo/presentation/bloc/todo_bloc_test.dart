import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_sprint/core/error/failures.dart';
import 'package:todo_sprint/core/usecases/usecase.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/create_todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/create_todo.dart'
    as create show Params;
import 'package:todo_sprint/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/get_all_todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/get_todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/update_todo.dart';
import 'package:todo_sprint/features/todo/presentation/bloc/todo_bloc.dart';
// import 'package:bloc_test/bloc_test.dart';
import 'todo_bloc_test.mocks.dart';

@GenerateMocks([CreateTodo, GetAllTodos, GetTodo, UpdateTodo, DeleteTodo])
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
      verify: (bloc) => mockCreateTodo(const create.Params(todo: testTodo)),
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
      verify: (bloc) => mockCreateTodo(const create.Params(todo: testTodo)),
    );
    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a ServerFailure is returned',
      build: () {
        when(mockCreateTodo(const create.Params(todo: testTodo)))
            .thenAnswer((_) async => const Left(ServerFailure()));

        return bloc;
      },
      act: (bloc) => bloc.add(const TodoCreated(todo: testTodo)),
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
      'Should emit state status TodoStatus.[loading, failure] when a ServerFailure is returned',
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
      'Should get data from the createTodo usecase ',
      build: () {
        when(mockGetAllTodos(NoParams())).thenAnswer(
          (_) async => const Right(testList),
        );

        return bloc;
      },
      act: (bloc) => bloc.add(const TodoFetchedAll()),
      verify: (bloc) => mockGetAllTodos(NoParams()),
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, success] when a all todos are fetched',
      build: () {
        when(mockGetAllTodos(NoParams()))
            .thenAnswer((_) async => const Right(testList));
        return bloc;
      },
      act: (bloc) => bloc.add(const TodoFetchedAll()),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        const TodoState(todos: testList, status: TodoStatus.success),
      ],
      verify: (bloc) => mockGetAllTodos(NoParams()),
    );
    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a ServerFailure is returned',
      build: () {
        when(mockGetAllTodos(NoParams()))
            .thenAnswer((_) async => const Right(testList));
        return bloc;
      },
      act: (bloc) => bloc.add(const TodoFetchedAll()),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        const TodoState(todos: [], status: TodoStatus.failure),
      ],
    );

    blocTest(
      'Should emit state status TodoStatus.[loading, failure] when a ServerFailure is returned',
      build: () {
        when(mockGetAllTodos(NoParams()))
            .thenAnswer((_) async => const Right(testList));
        return bloc;
      },
      act: (bloc) => bloc.add(const TodoFetchedAll()),
      expect: () => [
        const TodoState(todos: [], status: TodoStatus.loading),
        const TodoState(todos: [], status: TodoStatus.failure),
      ],
    );
  });


  
  group('TodoByIdFetched', () {});
  group('TodoUpdated', () {});
  group('TodoMarkAsCompleted', () {});
  group('TodoMarkAsIncomplete', () {});
  group('TodoClearCompleted', () {});
}
