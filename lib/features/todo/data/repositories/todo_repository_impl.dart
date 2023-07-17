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
    // TODO: createTodo - Account for Internet Access (Offline/Online)

    try {
      final createdTodo = await remoteDataSource.createTodo(todo as TodoModel);
      return Right(createdTodo);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Todo>>> getAllTodos() async {
    // TODO: getAllTodos - Account for Internet Access (Offline/Online)
    try {
      final todos = await remoteDataSource.getAllTodos();
      return Right(todos);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Todo>> getTodoById(String todoId) async {
    // TODO: getTodoById - Account for Internet Access (Offline/Online)

    try {
      final fetchedTodo = await remoteDataSource.getTodoById(todoId);
      return Right(fetchedTodo);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Todo>> updateTodo(Todo todo) async {
    // TODO: updateTodo - Account for Internet Access (Offline/Online)
    try {
      final updatedTodo = await remoteDataSource.updateTodo(todo as TodoModel);
      return Right(updatedTodo);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteTodo(String todoId) async {
    // TODO: deleteTodo - Account for Internet Access (Offline/Online)

    try {
      final deleteResponseString = await remoteDataSource.deleteTodo(todoId);
      return Right(deleteResponseString);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }
}
