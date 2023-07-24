import 'package:dartz/dartz.dart';
import 'package:todo_sprint/core/error/exceptions.dart';
import 'package:todo_sprint/core/error/failures.dart';
import 'package:todo_sprint/core/network/network_info.dart';
import 'package:todo_sprint/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:todo_sprint/features/todo/data/models/todo_model.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/repositories/todo_repository.dart';
import '../datasources/todo_local_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;
  final TodoRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const TodoRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Todo>> createTodo(Todo todo) async {
    try {
      // final hasInternet = await networkInfo.isConnected;
      final todoModel = TodoModel(
          id: todo.id,
          title: todo.title,
          description: todo.description,
          dateCreated: todo.dateCreated,
          dateUpdated: todo.dateUpdated);

      // if (hasInternet) {
        final createdTodo = await remoteDataSource.createTodo(todoModel);
      //   await localDataSource.createTodo(todoModel);
        return Right(createdTodo);
      // } else {
        // final createdTodo = await localDataSource.createTodo(todoModel);

        // return Right(createdTodo);
      // }
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Todo>>> getAllTodos() async {
    try {
      // final hasInternet = await networkInfo.isConnected;

      // if (hasInternet) {
        final todos = await remoteDataSource.getAllTodos();

        return Right(todos);
      // } else {
        // final todos = await localDataSource.getAllTodos();
        // return Right(todos);
      // }
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Todo>> getTodoById(String todoId) async {
    try {
      // final hasInternet = await networkInfo.isConnected;

      // if (hasInternet) {
        final fetchedTodo = await remoteDataSource.getTodoById(todoId);
        return Right(fetchedTodo);
      // } else {
        // final fetchedTodo = await localDataSource.getTodoById(todoId);
        // return Right(fetchedTodo);
      // }
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Todo>> updateTodo(Todo todo) async {
    try {
      // final hasInternet = await networkInfo.isConnected;
      final todoModel = TodoModel(
          id: todo.id,
          title: todo.title,
          description: todo.description,
          dateCreated: todo.dateCreated,
          dateUpdated: todo.dateUpdated);
      // if (hasInternet) {
        final updatedTodo = await remoteDataSource.updateTodo(todoModel);
      //   await localDataSource.updateTodo(todoModel);
        return Right(updatedTodo);
      // } else {
        // final updatedTodo = await localDataSource.updateTodo(todoModel);
        // return Right(updatedTodo);
      // }
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> deleteTodo(String todoId) async {
    try {
      // final hasInternet = await networkInfo.isConnected;

      // if (hasInternet) {
        final deleteResponseString = await remoteDataSource.deleteTodo(todoId);
      //   await localDataSource.deleteTodo(todoId);
        return Right(deleteResponseString);
      // } else {
        // final deleteResponseString = await localDataSource.deleteTodo(todoId);
        // return Right(deleteResponseString);
      // }
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is ServerException) {
      return const ServerFailure();
    } else if (exception is CacheException) {
      return const CacheFailure();
    } else if (exception is NotFoundException) {
      return const NotFoundFailure();
    } else if (exception is NetworkException) {
      return const NetworkFailure();
    } else if (exception is DatabaseException) {
      return const DatabaseFailure();
    }

    return const UnexpectedFailure();
  }
}
