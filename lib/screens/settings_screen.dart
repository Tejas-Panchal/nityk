import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(Widget) push;
  const SettingsScreen({super.key, required this.push});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Settings', style: NtkText.headlineLarge));
  }
}
