

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, box, child) {
        final isDark = box.get('isDark', defaultValue: false);
        return Switch(
          value: isDark,
          onChanged: (value) => box.put('isDark', value),
        );
      },
    );
  }
}
