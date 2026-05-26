import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../services/services.dart';

class TasksScreen extends StatefulWidget {
  final void Function(Widget) push;
  const TasksScreen({super.key, required this.push});
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _showEditDialog = false;
  Task? _editingTask;

  @override
  void initState() {
    super.initState();
    TaskService.instance.addListener(_onChanged);
  }

  @override
  void dispose() {
    TaskService.instance.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final s = TaskService.instance;
    final incomplete = s.incompleteTasks;
    final completed = s.completedTasks;

    if (incomplete.isEmpty && completed.isEmpty) {
      return const Center(
        child: Text('No tasks yet', style: NtkText.bodyMedium),
      );
    }

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            ...incomplete.map(
              (task) => NtkTaskTile(
                task: task,
                onToggle: () async => s.toggleComplete(task.id!),
                onEdit: () {
                  setState(() {
                    _editingTask = task;
                    _showEditDialog = true;
                  });
                },
                onDelete: () async => s.delete(task.id!),
              ),
            ),
            const SizedBox(height: 8),
            if (completed.isNotEmpty)
              NtkSection(
                title: 'Completed (${completed.length})',
                children: completed
                    .map(
                      (task) => NtkTaskTile(
                        task: task,
                        onToggle: () async => s.toggleComplete(task.id!),
                        onEdit: () {
                          setState(() {
                            _editingTask = task;
                            _showEditDialog = true;
                          });
                        },
                        onDelete: () async => s.delete(task.id!),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
        if (_showEditDialog && _editingTask != null)
          NtkTaskDialog(
            task: _editingTask,
            onClose: () {
              setState(() {
                _showEditDialog = false;
                _editingTask = null;
              });
              s.load();
            },
          ),
      ],
    );
  }
}
