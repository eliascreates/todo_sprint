import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/routes/app_routes.dart';
import 'core/themes/app_theme.dart';
import 'injector_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
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
    );
  }
}
