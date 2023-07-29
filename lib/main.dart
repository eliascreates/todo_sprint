import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/routes/app_routes.dart';
import 'config/themes/app_theme.dart';
import 'features/todo/domain/usecases/create_todo.dart';
import 'features/todo/domain/usecases/delete_todo.dart';
import 'features/todo/domain/usecases/get_all_todo.dart';
import 'features/todo/domain/usecases/get_todo.dart';
import 'features/todo/domain/usecases/update_todo.dart';
import 'features/todo/presentation/bloc/todo_bloc.dart';
import 'injector_container.dart' as di;
import 'injector_container.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoBloc>(
      create: (context) => TodoBloc(
        createTodo: sl<CreateTodo>(),
        getAllTodos: sl<GetAllTodos>(),
        getTodo: sl<GetTodo>(),
        updateTodo: sl<UpdateTodo>(),
        deleteTodo: sl<DeleteTodo>(),
      )..add(const TodoFetchedAll()),
      child: ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, box, child) {
          final isDark = box.get('isDark', defaultValue: false);
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Todo Sprint',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              initialRoute: AppRoutes.home,
              onGenerateRoute: AppRoutes.onGenerateRoute);
        },
      ),
    );
  }
}
