import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sprint/core/routes/app_routes.dart';
// import 'package:todo_sprint/features/todo/domain/usecases/delete_todo.dart';
// import 'package:todo_sprint/features/todo/domain/usecases/get_all_todo.dart';
// import 'package:todo_sprint/features/todo/domain/usecases/get_todo.dart';
// import 'package:todo_sprint/features/todo/domain/usecases/update_todo.dart';
// import 'package:todo_sprint/injector_container.dart';
// import '../../domain/entities/todo.dart';
// import '../../domain/usecases/create_todo.dart';
import '../bloc/todo_bloc.dart';
import '../widgets/todo_list_tile.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text("Todo Sprint")),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: ((context, state) {
          // return CupertinoScrollbar(
          //   child: ListView(
          //     children: [
          //       for (var i = 0; i < 5; i++)
          //         TodoListTile(
          //           todo: Todo(
          //             id: '123',
          //             title: '${i + 1} - Study SOLID Principles',
          //             description:
          //                 'Consistency is key when it comes to naming files and folders. Establish naming conventions and patterns within your project or team and stick to them consistently. This consistency will make it easier for team members to understand and navigate the codebase.',
          //             dateCreated: "2023-07-19T12:26:51.135Z",
          //             dateUpdated: "2023-07-24T12:26:51.135Z",
          //             isCompleted: i % 2 == 0,
          //           ),
          //           onToggleComplete: (isCompleted) {
          //             context.read<TodoBloc>().add(
          //                   TodoToggleCompleted(
          //                     todo: Todo(
          //                       id: '123',
          //                       title: '${i + 1} - Study SOLID Principles',
          //                       description:
          //                           'Consistency is key when it comes to naming files and folders. Establish naming conventions and patterns within your project or team and stick to them consistently. This consistency will make it easier for team members to understand and navigate the codebase.',
          //                       dateCreated: "2023-07-19T12:26:51.135Z",
          //                       dateUpdated: "2023-07-19T12:26:51.135Z",
          //                     ),
          //                   ),
          //                 );
          //           },
          //           onDismiss: (direction) {
          //             // context
          //             //     .read<TodoBloc>()
          //             //     .add(const TodoDeleted(todoId: '-'));
          //           },
          //           onTap: () {
          //             Navigator.of(context).pushNamed(
          //               AppRoutes.editPage,
          //               arguments: Todo(
          //                 id: '123',
          //                 title: '${i + 1} - Study SOLID Principles',
          //                 description:
          //                     'Consistency is key when it comes to naming files and folders. Establish naming conventions and patterns within your project or team and stick to them consistently. This consistency will make it easier for team members to understand and navigate the codebase.',
          //                 dateCreated: "2023-07-19T12:26:51.135Z",
          //                 dateUpdated: "2023-07-24T12:26:51.135Z",
          //                 isCompleted: i % 2 == 0,
          //               ),
          //             );
          //           },
          //         ),
          //     ],
          //   ),
          // );
          debugPrint(state.todos.toString());
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
                    onToggleComplete: (isCompleted) {
                      context
                          .read<TodoBloc>()
                          .add(TodoToggleCompleted(todo: todo));
                    },
                    onDismiss: (direction) {
                      context
                          .read<TodoBloc>()
                          .add(TodoDeleted(todoId: todo.id));
                    },
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.editPage,
                        arguments: todo,
                      );
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
