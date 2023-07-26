// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:todo_sprint/core/error/failures.dart';
import 'package:todo_sprint/core/usecases/usecase.dart';
import 'package:todo_sprint/features/todo/domain/repositories/todo_repository.dart';

import '../entities/todo.dart';

class UpdateTodo extends Usecase<Todo, Params> {
  final TodoRepository repository;
  const UpdateTodo(this.repository);

  @override
  Future<Either<Failure, Todo>> call(Params params) async {
    return await repository.updateTodo(
      params.todoId,
      title: params.title,
      description: params.description,
      isComplete: params.isComplete,
    );
  }
}

class Params extends Equatable {
  final String todoId;
  final String? title;
  final String? description;
  final bool? isComplete;

  const Params({required this.todoId, this.title, this.description, this.isComplete});

  @override
  List<Object?> get props => [todoId];
}
