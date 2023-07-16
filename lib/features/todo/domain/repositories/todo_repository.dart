import 'package:dartz/dartz.dart';
import 'package:todo_sprint/core/error/failures.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';

abstract class TodoRepository {
  //GET ALL TASKS
  Future<Either<Failure, List<Todo>>> getAllTasks();

  //GET ONE TASK BY ID
  Future<Either<Failure, Todo>> getTaskById(String todoId);

  //CREATE ONE TASK BY ID
  Future<Either<Failure, void>> createTask(Todo todo);

  //UPDATE A TASK
  Future<Either<Failure, void>> updateTask(Todo todo);

  //DELETE A TASK
  Future<Either<Failure, void>> deleteTask(String todoId);
}
