import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';
import 'package:nityk/widgets/widgets.dart';
import 'package:nityk/models/models.dart';

class NtkTaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const NtkTaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<NtkTaskTile> createState() => _NtkTaskTileState();
}

class _NtkTaskTileState extends State<NtkTaskTile> {
  bool _showActions = false;
  Timer? _hideTimer;

  void _showActionsForAWhile() {
    _hideTimer?.cancel();
    setState(() => _showActions = true);
    _hideTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) setState(() => _showActions = false);
    });
  }

  void _hideActionsNow() {
    _hideTimer?.cancel();
    setState(() => _showActions = false);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: NtkColors.border, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _hideActionsNow();
                widget.onToggle();
              },
              child: Row(
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
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _showActionsForAWhile,
              child: Container(
                height: double.infinity,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_showActions) ...[
                      GestureDetector(
                        onTap: () {
                          _hideActionsNow();
                          widget.onEdit();
                        },
                        child: const NtkIcon(
                          icon: NtkIcons.edit,
                          size: 24,
                          color: NtkColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          _hideActionsNow();
                          widget.onDelete();
                        },
                        child: const NtkIcon(
                          icon: NtkIcons.delete,
                          size: 24,
                          color: NtkColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
