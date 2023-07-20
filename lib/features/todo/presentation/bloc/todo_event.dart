part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
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
  final String todoId;

  const TodoByIdFetched({required this.todoId});
  @override
  List<Object> get props => [todoId];
}

class TodoUpdated extends TodoEvent {
  final Todo todo;

  const TodoUpdated({required this.todo});
  @override
  List<Object> get props => [todo];
}

class TodoDeleted extends TodoEvent {
  final String todoId;

  const TodoDeleted({required this.todoId});
  @override
  List<Object> get props => [todoId];
}