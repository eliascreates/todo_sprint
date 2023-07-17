import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_sprint/core/error/failures.dart';
import 'package:todo_sprint/core/usecases/usecase.dart';
import 'package:todo_sprint/features/todo/domain/repositories/todo_repository.dart';

class DeleteTask extends Usecase<String, Params> {
  final TodoRepository repository;

  const DeleteTask(this.repository);

  @override
  Future<Either<Failure, String>> call(Params params) async {
    return await repository.deleteTask(params.todoId);
  }
}

class Params extends Equatable {
  final String todoId;
  const Params({required this.todoId});

  @override
  List<Object?> get props => [todoId];
}
