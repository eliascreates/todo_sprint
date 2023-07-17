// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:todo_sprint/core/error/failures.dart';
import 'package:todo_sprint/core/usecases/usecase.dart';
import 'package:todo_sprint/features/todo/domain/repositories/todo_repository.dart';

import '../entities/todo.dart';

class GetTodo extends Usecase<Todo, Params> {
  final TodoRepository repository;
  const GetTodo(this.repository);

  @override
  Future<Either<Failure, Todo>> call(Params params) async {
    return await repository.getTodoById(params.todoId);
  }
}

class Params extends Equatable {
  final String todoId;
  const Params({required this.todoId});

  @override
  List<Object?> get props => [todoId];
}