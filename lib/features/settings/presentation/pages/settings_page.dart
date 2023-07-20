import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
      appBar: AppBar(title: const Text('Todo Settings')),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: Hive.box('settings').listenable(),
          builder: (context, box, child) {
            final isDark = box.get('isDark', defaultValue: false);
            return Switch(
              value: isDark,
              onChanged: (value) => box.put('isDark', value),
            );
          },
        ),
      ),
    );
  }
}
