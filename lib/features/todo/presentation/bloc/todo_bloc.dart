import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sprint/core/error/failures.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/create_todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/create_todo.dart'
    as create show Params;
import 'package:todo_sprint/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/get_all_todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/get_todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/update_todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero';
const String cacheFailureMessage = 'Server Failure';
const String serverFailureMessage = 'Cache Failure';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final CreateTodo createTodo;
  final GetAllTodos getAllTodos;
  final GetTodo getTodo;
  final UpdateTodo updateTodo;
  final DeleteTodo deleteTodo;

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

    on<TodoMarkAsCompleted>(_onTodoMarkAsCompleted);
    on<TodoMarkAsIncomplete>(_onTodoMarkAsIncomplete);
    on<TodoClearCompleted>(_onTodoClearCompleted);
  }

  Future<void> _onTodoCreated(
    TodoCreated event,
    Emitter<TodoState> emit,
  ) async {
    emit(state.copyWith(status: TodoStatus.loading));
    final result = await createTodo(create.Params(todo: event.todo));

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
              errorMessage: null);
        },
      ),
    );
  }

  Future<void> _onTodoByIdFetched(
    TodoByIdFetched event,
    Emitter<TodoState> emit,
  ) async {
    // TODO: implement event handler
  }

  Future<void> _onTodoFetchedAll(
    TodoFetchedAll event,
    Emitter<TodoState> emit,
  ) async {

  }

  Future<void> _onTodoUpdated(
    TodoUpdated event,
    Emitter<TodoState> emit,
  ) async {
    // TODO: implement event handler
  }

  Future<void> _onTodoDeleted(
    TodoDeleted event,
    Emitter<TodoState> emit,
  ) async {
    // TODO: implement event handler
  }

  Future<void> _onTodoMarkAsIncomplete(
    TodoMarkAsIncomplete event,
    Emitter<TodoState> emit,
  ) async {
    // TODO: implement event handler
  }

  Future<void> _onTodoMarkAsCompleted(
    TodoMarkAsCompleted event,
    Emitter<TodoState> emit,
  ) async {
    // TODO: implement event handler
  }

  Future<void> _onTodoClearCompleted(
    TodoClearCompleted event,
    Emitter<TodoState> emit,
  ) async {
    // TODO: implement event handler
  }
}

extension _MapFailureToMessage on Failure {
  String get message {
    switch (this) {
      case ServerFailure():
        return serverFailureMessage;
      case CacheFailure():
        return cacheFailureMessage;
      default:
        return "Unexpected Error";
    }
  }
}
