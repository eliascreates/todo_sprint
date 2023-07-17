import 'package:dartz/dartz.dart';
import 'package:todo_sprint/core/error/failures.dart';
import 'package:todo_sprint/core/usecases/usecase.dart';
import 'package:todo_sprint/features/todo/domain/repositories/todo_repository.dart';

import '../entities/todo.dart';

class GetTasks extends Usecase<List<Todo>, NoParams> {
  final TodoRepository repository;

  const GetTasks(this.repository);

  @override
  Future<Either<Failure, List<Todo>>> call(NoParams params) async {
    return await repository.getAllTasks();
  }
}
