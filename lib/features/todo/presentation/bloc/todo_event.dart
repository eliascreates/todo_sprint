part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class TodoCreated extends TodoEvent {
  final Todo todo;

  const TodoCreated({required this.todo});
  @override
  List<Object> get props => [todo];
}

class TodoFetchedAll extends TodoEvent {
  const TodoFetchedAll();
}

class TodoByIdFetched extends TodoEvent {
  const TodoByIdFetched({required this.todoId});

  final String todoId;

  @override
  List<Object> get props => [todoId];
}

class TodoUpdated extends TodoEvent {
  const TodoUpdated({required this.todo});

  final Todo todo;

  @override
  List<Object> get props => [todo];
}

class TodoMarkAsCompleted extends TodoEvent {
  const TodoMarkAsCompleted();
}

class TodoMarkAsIncomplete extends TodoEvent {
  const TodoMarkAsIncomplete();
}

class TodoClearCompleted extends TodoEvent {
  const TodoClearCompleted();
}


class TodoSubmitted extends TodoEvent {
  const TodoSubmitted();
}

class TodoDeleted extends TodoEvent {
  const TodoDeleted({required this.todoId});

  final String todoId;

  @override
  List<Object> get props => [todoId];
}