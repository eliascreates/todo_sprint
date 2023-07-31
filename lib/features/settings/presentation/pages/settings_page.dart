import 'package:flutter/material.dart';
import 'package:todo_sprint/core/constants/strings.dart';
import '../widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.todoSettingsAppbarTitle)),
      body: const Center(
        child: ThemeSwitch(),
      ),
    );
  }
}
