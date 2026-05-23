import 'package:flutter/material.dart';
import 'package:Nityk/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:Nityk/main_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const NitykApp());
}

class NitykApp extends StatelessWidget {
  const NitykApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nityk',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const MainNavigationScreen(title: 'Nityk'),
    );
  }
}
