import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';
import 'package:nityk/widgets/widgets.dart';
import 'package:nityk/database/database_helper.dart';
import 'package:nityk/models/models.dart';

class TasksScreen extends StatefulWidget {
  final void Function(Widget) push;
  const TasksScreen({super.key, required this.push});
  @override
  State<TasksScreen> createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  List<Task> _tasks = [];
  bool _loading = true;
  bool _showEditDialog = false;
  Task? _editingTask;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final tasks = await DatabaseHelper.instance.getAllTasks();
    if (mounted) {
      setState(() {
        _tasks = tasks;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_loading)
          const Center(child: Text('Loading...'))
        else if (_tasks.isEmpty)
          const Center(
            child: Text('No tasks yet', style: NtkText.bodyMedium),
          )
        else
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              final task = _tasks[index];
              return NtkTaskTile(
                task: task,
                onToggle: () async {
                  await DatabaseHelper.instance.toggleComplete(task.id!);
                  loadTasks();
                },
                onEdit: () {
                  setState(() {
                    _editingTask = task;
                    _showEditDialog = true;
                  });
                },
                onDelete: () async {
                  await DatabaseHelper.instance.deleteTask(task.id!);
                  loadTasks();
                },
              );
            },
          ),
        if (_showEditDialog && _editingTask != null)
          NtkTaskDialog(
            task: _editingTask,
            onClose: () {
              setState(() {
                _showEditDialog = false;
                _editingTask = null;
              });
              loadTasks();
            },
          ),
      ],
    );
  }
}
