import 'package:flutter/widgets.dart';
import 'ntk_icon.dart';
import 'ntk_base_tile.dart';
import '../theme/theme.dart';
import '../models/models.dart';

class NtkTaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final List<int> tagColors;

  const NtkTaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    this.tagColors = const [],
  });

  @override
  Widget build(BuildContext context) {
    return NtkBaseTile(
      onTap: onToggle,
      tagColors: tagColors,
      tagPaddingLeft: 40,
      leading: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 8),
          NtkIcon(
            icon: task.isCompleted
                ? NtkIcons.taskCompleted
                : NtkIcons.taskRemaining,
            size: 24,
            color: NtkColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task.title,
              style: NtkText.headlineMedium.copyWith(
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (task.dueDate != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                child: Text(
                  '${task.dueDate!.day.toString().padLeft(2, '0')}-'
                  '${task.dueDate!.month.toString().padLeft(2, '0')}-'
                  '${task.dueDate!.year}',
                  style: NtkText.labelSmall.copyWith(fontSize: 14),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              ['H', 'M', 'L'][task.priority - 1],
              style: NtkText.labelLarge.copyWith(
                color: task.priority == 1
                    ? NtkColors.priorityHigh
                    : task.priority == 3
                    ? NtkColors.priorityLow
                    : NtkColors.priorityMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
