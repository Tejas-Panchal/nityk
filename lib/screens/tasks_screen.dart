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
    LogTimerService.instance.addListener(_onTimerChanged);
  }

  @override
  void dispose() {
    TaskService.instance.removeListener(_onChanged);
    LogTimerService.instance.removeListener(_onTimerChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});
  void _onTimerChanged() => setState(() {});

  Widget _buildTaskTile(Task task) {
    return NtkTaskTile(
      task: task,
      onToggle: () async => TaskService.instance.toggleComplete(task.id!),
      onEdit: () {
        setState(() {
          _editingTask = task;
          _showEditDialog = true;
        });
      },
      onDelete: () async => TaskService.instance.delete(task.id!),
    );
  }

  List<Task> _sortFlat(List<Task> tasks, String sortOrder) {
    final sorted = List<Task>.from(tasks);
    switch (sortOrder) {
      case 'Old->New':
        sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      case 'New->Old':
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return sorted;
  }

  List<List<Task>> _groupByPriority(List<Task> tasks) {
    final high = tasks.where((t) => t.priority == 1).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final medium = tasks.where((t) => t.priority == 2).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final low = tasks.where((t) => t.priority == 3).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return [high, medium, low];
  }

  Color? _priorityColor(String label) {
    return switch (label) {
      'High' => NtkColors.priorityHighDark,
      'Medium' => NtkColors.priorityMediumDark,
      'Low' => NtkColors.priorityLowDark,
      _ => null,
    };
  }

  List<Widget> _buildGrouped(List<Task> tasks) {
    final groups = _groupByPriority(tasks);
    final labels = ['High', 'Medium', 'Low'];
    final sections = <Widget>[];
    for (int i = 0; i < 3; i++) {
      if (groups[i].isNotEmpty) {
        sections.add(
          NtkTasksSection(
            backgroundColor: _priorityColor(labels[i]),
            title: '${labels[i]} (${groups[i].length})',
            isOpen: true,
            children: groups[i].map(_buildTaskTile).toList(),
          ),
        );
      }
    }
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final sortOrder = SettingsService.instance.sortOrder;
    final s = TaskService.instance;
    final incomplete = s.incompleteTasks;
    final completed = s.completedTasks;
    final sortedCompleted = List<Task>.from(completed)
      ..sort((a, b) {
        final aTime = a.completedAt ?? a.createdAt;
        final bTime = b.completedAt ?? b.createdAt;
        return bTime.compareTo(aTime);
      });

    if (incomplete.isEmpty && completed.isEmpty) {
      return const Center(
        child: Text('No tasks yet', style: NtkText.bodyLarge),
      );
    }

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            8 + LogTimerService.instance.bottomPillPadding,
          ),
          children: [
            if (sortOrder == 'Grouped')
              ..._buildGrouped(incomplete)
            else ...[
              ..._sortFlat(incomplete, sortOrder).map(_buildTaskTile),
              SizedBox(height: 8),
            ],

            if (completed.isNotEmpty)
              NtkTasksSection(
                key: const ValueKey('completed'),
                title: 'Completed (${completed.length})',
                isOpen: false,
                children: sortedCompleted.map(_buildTaskTile).toList(),
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
