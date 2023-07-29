import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sprint/features/todo_tab/presentation/cubit/todo_tab_cubit.dart';

class TodoAppBar extends StatelessWidget {
  const TodoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<TodoTabCubit, TodoTab>(
      builder: (context, selectedTab) {
        return SliverToBoxAdapter(
          child: TabBar(
            automaticIndicatorColorAdjustment: true,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: theme.indicatorColor,
            labelColor: theme.colorScheme.secondary,
            unselectedLabelColor: theme.disabledColor,
            labelStyle: const TextStyle(fontSize: 18),
            unselectedLabelStyle: const TextStyle(fontSize: 14),
            splashBorderRadius: BorderRadius.circular(20),
            controller: context.read<TodoTabCubit>().tabController,
            onTap: (index) {
              context.read<TodoTabCubit>().selectTab(TodoTab.values[index]);
            },
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Complete'),
              Tab(text: 'Incomplete'),
            ],
          ),
        );
      },
    );
  }
}
