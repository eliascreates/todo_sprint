part of 'todo_bloc.dart';

enum TodoStatus { initial, loading, success, failure }

class TodoState extends Equatable {
  const TodoState({
    this.todos = const <Todo>[],
    this.status = TodoStatus.initial,
    this.errorMessage,
  });

  final List<Todo> todos;
  final TodoStatus status;
  final String? errorMessage;

  TodoState copyWith({
    List<Todo>? todos,
    TodoStatus? status,
    String? errorMessage,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [todos, status];
}
