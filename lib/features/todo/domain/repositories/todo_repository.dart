import 'package:dartz/dartz.dart';
import 'package:todo_sprint/core/error/failures.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';

abstract class TodoRepository {
  //GET ALL TODOS
  Future<Either<Failure, List<Todo>>> getAllTodos();

  //GET ONE Todo BY ID
  Future<Either<Failure, Todo>> getTodoById(String todoId);

  //CREATE ONE Todo BY ID
  Future<Either<Failure, Todo>> createTodo(Todo todo);

  //UPDATE A Todo
  Future<Either<Failure, Todo>> updateTodo(Todo todo);

  //DELETE A Todo
  Future<Either<Failure, String>> deleteTodo(String todoId);
}
