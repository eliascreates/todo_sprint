part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class TodoCreated extends TodoEvent {
  final String title;
  final String description;

  const TodoCreated({required this.title, required this.description});
  @override
  List<Object> get props => [title, description];
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
  const TodoUpdated(
      {required this.todoId, this.title, this.description, this.isComplete});

  final String todoId;
  final String? title;
  final String? description;
  final bool? isComplete;

  @override
  List<Object?> get props => [todoId, title, description, isComplete];
}


class TodoDeleted extends TodoEvent {
  const TodoDeleted({required this.todoId});

  final String todoId;

  @override
  List<Object> get props => [todoId];
}

class TodoToggleCompleted extends TodoEvent {
  const TodoToggleCompleted({required this.todoId});

  final String todoId;

  @override
  List<Object> get props => [todoId];
}

class TodoClearCompleted extends TodoEvent {
  const TodoClearCompleted();
}