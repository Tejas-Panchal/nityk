import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';

class TasksScreen extends StatefulWidget {
  final void Function(Widget) push;
  const TasksScreen({super.key, required this.push});
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Tasks', style: NtkText.headlineLarge));
  }
}
