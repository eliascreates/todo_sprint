// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:todo_sprint/core/error/failures.dart';
import 'package:todo_sprint/core/usecases/usecase.dart';
import 'package:todo_sprint/features/todo/domain/repositories/todo_repository.dart';

import '../entities/todo.dart';

class UpdateTask extends Usecase<Todo, Params> {
  final TodoRepository repository;
  const UpdateTask(this.repository);

  @override
  Future<Either<Failure, Todo>> call(Params params) async {
    return await repository.updateTask(params.todo);
  }
}

class Params extends Equatable {
  final Todo todo;

  const Params({required this.todo});

  @override
  List<Object?> get props => [todo];
}
