import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/get_all_todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/get_todo.dart';
import 'package:todo_sprint/features/todo/domain/usecases/update_todo.dart';
import 'package:todo_sprint/injector_container.dart';
import '../../domain/usecases/create_todo.dart';
import '../bloc/todo_bloc.dart';
import '../widgets/todo_list_tile.dart';

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
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: ((context, state) {
          return CupertinoScrollbar(
            child: ListView(
              children: [
                for (var i = 0; i < 5; i++)
                  TodoListTile(
                    todo: Todo(
                      id: '123',
                      title: '${i + 1} - Study SOLID Principles',
                      description:
                          'Consistency is key when it comes to naming files and folders. Establish naming conventions and patterns within your project or team and stick to them consistently. This consistency will make it easier for team members to understand and navigate the codebase.',
                      dateCreated: "2023-07-19T12:26:51.135Z",
                      dateUpdated: "2023-07-19T12:26:51.135Z",
                    ),
                    onToggleComplete: (isCompleted) {
                      context.read<TodoBloc>().add(isCompleted
                          ? const TodoMarkAsCompleted()
                          : const TodoMarkAsIncomplete());
                    },
                    onDismiss: (direction) {
                      // context
                      //     .read<TodoBloc>()
                      //     .add(const TodoDeleted(todoId: '-'));
                    },
                    onTap: () {
                      // Navigator.of(context).pushNamed(AppRoutes.editPage);
                    },
                  ),
              ],
            ),
          );

          if (state.todos.isEmpty) {
            if (state.status == TodoStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status != TodoStatus.success) {
              return const SizedBox();
            } else {
              return Center(
                child: Text(
                  'No Todos',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            }
          }

          return CupertinoScrollbar(
            child: ListView(
              children: [
                for (final todo in state.todos)
                  TodoListTile(
                    todo: todo,
                    onToggleComplete: (isCompleted) {
                      context.read<TodoBloc>().add(isCompleted
                          ? const TodoMarkAsCompleted()
                          : const TodoMarkAsIncomplete());
                    },
                    onDismiss: (direction) {
                      context
                          .read<TodoBloc>()
                          .add(TodoDeleted(todoId: todo.id));
                    },
                    onTap: () {
                      // Navigator.of(context).pushNamed(AppRoutes.editPage);
                    },
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
