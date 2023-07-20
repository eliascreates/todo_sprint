import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sprint/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/get_all_todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/get_todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/update_todo.dart';
import 'package:todo_sprint/injector_container.dart';
import '../../domain/usecases/create_todo.dart';
import '../bloc/todo_bloc.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoBloc>(
      create: (context) => TodoBloc(
        createTodo: sl<CreateTodo>(),
        getAllTodos: sl<GetAllTodos>(),
        getTodo: sl<GetTodo>(),
        updateTodo: sl<UpdateTodo>(),
        deleteTodo: sl<DeleteTodo>(),
      ),
      child: const TodoView(),
    );
  }
}

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo Sprint")),
      body: const Center(child: Text("Welcome Home")),
    );
  }
}
