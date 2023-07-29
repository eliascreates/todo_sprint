import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_sprint/core/constants/strings.dart';
import 'package:todo_sprint/core/constants/values.dart';
import 'package:todo_sprint/features/todo_tab/presentation/cubit/todo_tab_cubit.dart';

import '../bloc/todo_bloc.dart';
import '../widgets/widgets.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoTabCubit>(
      create: (context) => TodoTabCubit(tabController: _tabController),
      child: const TodoHomeView(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class TodoHomeView extends StatelessWidget {
  const TodoHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverAppBar(
            title: Text(Strings.homeScreenTitle),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Values.defaultPadding / 2,
                vertical: Values.defaultPadding,
              ),
              child: Builder(builder: (context) {
                final todos =
                    context.select((TodoBloc bloc) => bloc.state.todos);
                final completeTodoLength =
                    todos.where((todo) => todo.isCompleted).length;
                final incompleteTodoLength = todos.length - completeTodoLength;

                return TodoStatistics(
                  totalTodos: todos.length,
                  completedTodos: completeTodoLength,
                  incompleteTodos: incompleteTodoLength,
                );
              }),
            ),
          ),
          const TodoAppBar(),
          const TodoListView(),
        ],
      ),
    );
  }
}
