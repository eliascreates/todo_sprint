import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sprint/config/routes/app_routes.dart';
import 'package:todo_sprint/core/constants/values.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';

import '../../../todo_tab/presentation/cubit/todo_tab_cubit.dart';
import '../bloc/todo_bloc.dart';
import 'todo_list_tile.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.bodySmall?.color;
    final selectedTab = context.watch<TodoTabCubit>().state;

    final todos = context.select((TodoBloc bloc) => bloc.state.todos);

    final sortedTodos = selectedTab == TodoTab.all
        ? todos
        : todos
            .where((todo) =>
                (selectedTab == TodoTab.complete && todo.isCompleted) ||
                (selectedTab == TodoTab.incomplete && !todo.isCompleted))
            .toList();

    final filteredTodos = List.from(sortedTodos);
    filteredTodos.sort((a, b) => b.dateUpdated.compareTo(a.dateUpdated));

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final todo = filteredTodos[index];

          return TodoListTile(
            todo: todo,
            onToggleComplete: (_) => toggleComplete(context, todo),
            onDismiss: (_) => deleteTodo(context, todo),
            onTap: () => editTodo(context, todo),
            popupItems: [
              PopupMenuItem(
                onTap: () => Future(() => editTodo(context, todo)),
                child: Row(
                  children: [
                    const Icon(Icons.edit),
                    const SizedBox(width: Values.defaultPadding),
                    Text(
                      'Edit',
                      style: TextStyle(color: captionColor),
                    ),
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
                    const SizedBox(width: Values.defaultPadding),
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
                    const SizedBox(width: Values.defaultPadding),
                    Text(
                      'Delete',
                      style: TextStyle(color: captionColor),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        childCount: filteredTodos.length,
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
