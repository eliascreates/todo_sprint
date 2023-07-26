import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final create.CreateTodo createTodo;
  final get_all.GetAllTodos getAllTodos;
  final get_todo.GetTodo getTodo;
  final update.UpdateTodo updateTodo;
  final delete.DeleteTodo deleteTodo;

  TodoBloc({
    required this.createTodo,
    required this.getAllTodos,
    required this.getTodo,
    required this.updateTodo,
    required this.deleteTodo,
  }) : super(const TodoState()) {
    on<TodoCreated>(_onTodoCreated);
    on<TodoFetchedAll>(_onTodoFetchedAll);
    on<TodoByIdFetched>(_onTodoByIdFetched);
    on<TodoUpdated>(_onTodoUpdated);
    on<TodoDeleted>(_onTodoDeleted);

    on<TodoToggleCompleted>(_onTodoToggleCompleted);

    on<TodoClearCompleted>(_onTodoClearCompleted);
  }

  Future<void> _onTodoCreated(
    TodoCreated event,
    Emitter<TodoState> emit,
  ) async {
    emit(state.copyWith(status: TodoStatus.loading));
    final result = await createTodo(
        create.Params(title: event.title, description: event.description));

    emit(
      await result.fold(
        (failure) async {
          return state.copyWith(
              status: TodoStatus.failure, errorMessage: failure.message);
        },
        (createdTodo) async {
          return state.copyWith(
            todos: <Todo>[...state.todos, createdTodo],
            status: TodoStatus.success,
            errorMessage: null,
          );
        },
      ),
    );
  }

  Future<void> _onTodoByIdFetched(
    TodoByIdFetched event,
    Emitter<TodoState> emit,
  ) async {
    emit(state.copyWith(status: TodoStatus.loading));

    final result = await getTodo(get_todo.Params(todoId: event.todoId));

    emit(
      await result.fold(
        (failure) async => state.copyWith(
            status: TodoStatus.failure, errorMessage: failure.message),
        (todo) async => state.copyWith(
          todos: <Todo>[...state.todos, todo],
          status: TodoStatus.success,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onTodoFetchedAll(
    TodoFetchedAll event,
    Emitter<TodoState> emit,
  ) async {
    emit(state.copyWith(status: TodoStatus.loading));

    final result = await getAllTodos(const NoParams());

    emit(
      await result.fold(
        (failure) async => state.copyWith(
            status: TodoStatus.failure, errorMessage: failure.message),
        (todos) async => state.copyWith(
          todos: todos,
          status: TodoStatus.success,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onTodoUpdated(
    TodoUpdated event,
    Emitter<TodoState> emit,
  ) async {
    emit(state.copyWith(status: TodoStatus.loading));

    final result = await updateTodo(update.Params(
      todoId: event.todoId,
      title: event.title,
      description: event.description,
    ));

    emit(
      await result.fold(
        (failure) async => state.copyWith(
            status: TodoStatus.failure, errorMessage: failure.message),
        (modifiedTodo) async {
          return state.copyWith(
            todos: state.todos
                .map((todo) => todo.id == modifiedTodo.id ? modifiedTodo : todo)
                .toList(),
            status: TodoStatus.success,
            errorMessage: null,
          );
        },
      ),
    );
  }

  Future<void> _onTodoDeleted(
    TodoDeleted event,
    Emitter<TodoState> emit,
  ) async {
    final result = await deleteTodo(delete.Params(todoId: event.todoId));

    emit(
      await result.fold(
        (failure) async => state.copyWith(
            status: TodoStatus.failure, errorMessage: failure.message),
        (response) async {
          final updatedTodos =
              state.todos.where((todo) => todo.id != event.todoId).toList();

          return state.copyWith(
              todos: updatedTodos, status: TodoStatus.success);
        },
      ),
    );
  }

  Future<void> _onTodoToggleCompleted(
    TodoToggleCompleted event,
    Emitter<TodoState> emit,
  ) async {
    final todo =
        state.todos.firstWhere((element) => element.id == event.todoId);
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);

    // Update the todo using the updateTodoUseCase
    final result = await updateTodo(update.Params(
      todoId: event.todoId,
      title: updatedTodo.title,
      description: updatedTodo.description,
      isComplete: updatedTodo.isCompleted,
    ));

    emit(
      await result.fold(
        (failure) async => state.copyWith(
            status: TodoStatus.failure, errorMessage: failure.message),
        (updatedTodo) async {
          final updatedTodos = state.todos.map((t) {
            if (t.id == event.todoId) {
              return updatedTodo;
            } else {
              return t;
            }
          }).toList();
          return state.copyWith(
              todos: updatedTodos, status: TodoStatus.success);
        },
      ),
    );
  }

  Future<void> _onTodoClearCompleted(
    TodoClearCompleted event,
    Emitter<TodoState> emit,
  ) async {
    if (state.todos.isEmpty) return;

    emit(state.copyWith(status: TodoStatus.loading));
    final updatedTodos =
        state.todos.where((todo) => !todo.isCompleted).toList();

    emit(state.copyWith(todos: updatedTodos, status: TodoStatus.success));
  }
}

extension _MapFailureToMessage on Failure {
  // ignore: unused_element
  String get message {
    switch (this) {
      case CacheFailure():
        return const CacheFailure().message;
      default:
        return "Unexpected Error";
    }
  }
}
