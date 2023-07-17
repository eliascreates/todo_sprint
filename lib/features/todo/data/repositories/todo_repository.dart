
import 'package:dartz/dartz.dart';
import 'package:todo_sprint/core/error/failures.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {




  @override
  Future<Either<Failure, Todo>> createTodo(Todo todo) {
    // TODO: implement createTodo
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> deleteTodo(String todoId) {
    // TODO: implement deleteTodo
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Todo>>> getAllTodos() {
    // TODO: implement getAllTodos
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Todo>> getTodoById(String todoId) {
    // TODO: implement getTodoById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Todo>> updateTodo(Todo todo) {
    // TODO: implement updateTodo
    throw UnimplementedError();
  }

}