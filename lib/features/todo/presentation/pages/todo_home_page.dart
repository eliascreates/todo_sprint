import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sprint/config/routes/app_routes.dart';
import 'package:todo_sprint/core/constants/strings.dart';

import '../bloc/todo_bloc.dart';
import '../widgets/todo_list_tile.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';

class TodoHomePage extends StatelessWidget {
  const TodoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TodoHomeView();
  }
}

class TodoHomeView extends StatelessWidget {
  const TodoHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(title: const Text(Strings.homeScreenTitle)),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state.status == TodoStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xffc03851),
                  duration: const Duration(seconds: 1),
                  content: Text(state.errorMessage ?? 'Unexpected Error'),
                ),
              );
          }
        },
        builder: ((context, state) {
          if (state.todos.isEmpty) {
            if (state.status == TodoStatus.loading) {
              context.read<TodoBloc>().add(const TodoFetchedAll());
              return const Center(child: CircularProgressIndicator());
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
                    onToggleComplete: (_) => toggleComplete(context, todo),
                    onDismiss: (_) => deleteTodo(context, todo),
                    onTap: () => editTodo(context, todo),
                    popupItems: [
                      PopupMenuItem(
                        onTap: () => editTodo(context, todo),
                        child: Row(
                          children: [
                            const Icon(Icons.edit),
                            const SizedBox(width: 20),
                            Text('Edit', style: TextStyle(color: captionColor)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () => toggleComplete(context, todo),
                        child: Row(
                          children: [
                            Icon(
                              todo.isCompleted ? Icons.close : Icons.done,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              todo.isCompleted ? 'Not Done' : 'Done',
                              style: TextStyle(color: captionColor),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () => deleteTodo(context, todo),
                        child: Row(
                          children: [
                            const Icon(Icons.delete),
                            const SizedBox(width: 20),
                            Text(
                              'Delete',
                              style: TextStyle(color: captionColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void deleteTodo(BuildContext context, Todo todo) {
    context.read<TodoBloc>().add(TodoDeleted(todoId: todo.id));
  }

  void toggleComplete(BuildContext context, Todo todo) {
    context.read<TodoBloc>().add(TodoToggleCompleted(todoId: todo.id));
  }

  void editTodo(BuildContext context, Todo todo) {
    Navigator.of(context).pushNamed(AppRoutes.editPage, arguments: todo);
  }
}
