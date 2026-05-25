import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';

class LogsScreen extends StatefulWidget {
  final void Function(Widget) push;
  const LogsScreen({super.key, required this.push});
  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Logs', style: NtkText.headlineLarge));
  }
}
