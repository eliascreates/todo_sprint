import 'package:dartz/dartz.dart';
import 'package:todo_sprint/core/error/failures.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/repositories/todo_repository.dart';
import '../datasources/todo_local_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  const TodoRepositoryImpl({required this.localDataSource});

  final TodoLocalDataSource localDataSource;

  @override
  Future<Either<Failure, Todo>> createTodo(
      {required String title, required String description}) async {
    try {
      final createdTodo = await localDataSource.createTodo(
          title: title, description: description);
      return Right(createdTodo);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Todo>>> getAllTodos() async {
    try {
      final todos = await localDataSource.getAllTodos();
      return Right(todos);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Todo>> getTodoById(String todoId) async {
    try {
      final fetchedTodo = await localDataSource.getTodoById(todoId);
      return Right(fetchedTodo);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Todo>> updateTodo(String todoId,
      {String? title, String? description, bool? isComplete}) async {
    try {
      final updatedTodo = await localDataSource.updateTodo(
        todoId,
        title: title,
        description: description,
        isComplete: isComplete,
      );
      return Right(updatedTodo);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteTodo(String todoId) async {
    try {
      final deleteResponseString = await localDataSource.deleteTodo(todoId);
      return Right(deleteResponseString);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}

//? May Use Different Failures Later On
  // Failure _mapExceptionToFailure(dynamic exception) {
  //   if (exception is CacheException) {
  //     return const CacheFailure();
  //   } else if (exception is NotFoundException) {
  //     return const NotFoundFailure();
  //   } else if (exception is NetworkException) {
  //     return const NetworkFailure();
  //   } else if (exception is DatabaseException) {
  //     return const DatabaseFailure();
  //   }

  //   return const UnexpectedFailure();
  // }