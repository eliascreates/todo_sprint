import 'package:flutter/material.dart';
import 'package:todo_sprint/features/home/presentation/pages/home_page.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sprint/features/settings/presentation/pages/settings_page.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';
import 'package:todo_sprint/features/todo/presentation/pages/todo_edit_page.dart';
// import 'package:todo_sprint/features/todo/domain/entities/todo.dart';

class AppRoutes {
  static const String home = '/';
  static const String editPage = '/editPage';
  static const String settingsPage = 'settings';

  const AppRoutes._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case editPage:
        if (settings.arguments is Todo) {
          return MaterialPageRoute(
            builder: (_) => TodoEditPage(todo: settings.arguments as Todo),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const TodoEditPage(),
        );
      case settingsPage:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
        );
      // case editPage:
      //   final todo = settings.arguments as Todo?;
      //   return MaterialPageRoute(
      //     fullscreenDialog: true,
      //     builder: (context) => BlocProvider(
      //       create: (context) => EditTodoBloc(
      //         todoRepository: context.read<TodoRepository>(),
      //         initialTodo: todo,
      //       ),
      //       child: EditTodoPage(initialTodo: todo),
      //     ),
      //   );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(child: Text('Route not found!')),
      ),
    );
  }
}
