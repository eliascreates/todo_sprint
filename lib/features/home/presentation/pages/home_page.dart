import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sprint/config/routes/app_routes.dart';
import 'package:todo_sprint/core/constants/strings.dart';
import 'package:todo_sprint/features/home/presentation/cubit/home_cubit.dart';
import 'package:todo_sprint/features/settings/presentation/pages/settings_page.dart';
import 'package:todo_sprint/features/todo/presentation/pages/todo_home_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);

    return Scaffold(
      body: IndexedStack(
        index: selectedTab.index,
        children: const [TodoHomePage(), SettingsPage()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        key: const Key('homeView_addTodo_floatingActionButton'),
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.editPage),
        tooltip: Strings.todoHomeAddTooltip,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _HomeTabButton(
            groupValue: selectedTab,
            value: HomeTab.todos,
            icon: const Icon(Icons.event_note_rounded),
            tooltip: Strings.tabHome,
          ),
          _HomeTabButton(
            groupValue: selectedTab,
            value: HomeTab.settings,
            icon: const Icon(Icons.settings_rounded),
            tooltip: Strings.tabSettings,
          ),
        ]),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton(
      {required this.groupValue,
      required this.value,
      required this.icon,
      this.tooltip});
  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      key: const Key('homeTabButton_switchTabs_iconButton'),
      splashRadius: 20,
      onPressed: () => context.read<HomeCubit>().setTab(value),
      iconSize: 32,
      icon: icon,
      color: groupValue != value
          ? Theme.of(context).focusColor
          : Theme.of(context).colorScheme.secondary,
    );
  }
}
