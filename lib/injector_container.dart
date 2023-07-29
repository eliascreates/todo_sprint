import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:todo_sprint/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:todo_sprint/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/repositories/todo_repository.dart';

import 'config/debug/bloc_observer.dart';
import 'features/todo/domain/usecases/create_todo.dart';
import 'features/todo/domain/usecases/delete_todo.dart';
import 'features/todo/domain/usecases/get_all_todo.dart';
import 'features/todo/domain/usecases/get_todo.dart';
import 'features/todo/domain/usecases/update_todo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ? FEATURES - Todo

  //Use cases
  sl.registerLazySingleton(() => CreateTodo(sl()));
  sl.registerLazySingleton(() => GetAllTodos(sl()));
  sl.registerLazySingleton(() => GetTodo(sl()));
  sl.registerLazySingleton(() => UpdateTodo(sl()));
  sl.registerLazySingleton(() => DeleteTodo(sl()));

  //Repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  //Data Sources
  sl.registerLazySingleton<TodoLocalDataSource>(
      () => TodoLocalDataSourceImpl(sl()));

  // ? EXTERNAL

  //Bloc Observer
  Bloc.observer = TodoAppObserver();

  //Hive Setup - Data Persistence
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox('settings');
  await Hive.openBox<Todo>('todo_box');

  sl.registerLazySingleton<HiveInterface>(() => Hive);

}
