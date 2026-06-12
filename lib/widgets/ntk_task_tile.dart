import 'dart:async';
import 'package:flutter/widgets.dart';
import 'ntk_icon.dart';
import '../theme/theme.dart';
import '../models/models.dart';

class NtkTaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final List<int> tagColors;

  const NtkTaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    this.tagColors = const [],
  });

  @override
  State<NtkTaskTile> createState() => _NtkTaskTileState();
}

class _NtkTaskTileState extends State<NtkTaskTile> {
  bool _showActions = false;
  Timer? _hideTimer;
  bool _showFullDescription = false;

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
      decoration: BoxDecoration(
        color: NtkColors.surface,
        border: Border(bottom: BorderSide(color: NtkColors.border, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 48,
            child: Row(
              children: [
                Expanded(
                  flex: 7,
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
                  flex: 3,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _showActionsForAWhile,
                    child: Container(
                      height: 48,
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
                          if (task.dueDate != null && !_showActions)
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
                                  style: NtkText.labelSmall.copyWith(
                                    fontSize: 14,
                                  ),
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
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (task.description != null && task.description!.isNotEmpty)
            LayoutBuilder(
              builder: (context, constraints) {
                final style = NtkText.bodyMedium.copyWith(
                  color: NtkColors.textSecondary,
                );
                final tp = TextPainter(
                  text: TextSpan(text: task.description!, style: style),
                  maxLines: 2,
                  textDirection: TextDirection.ltr,
                )..layout(maxWidth: constraints.maxWidth);
                return GestureDetector(
                  onTap: tp.didExceedMaxLines
                      ? () => setState(
                          () => _showFullDescription = !_showFullDescription,
                        )
                      : null,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 40,
                      right: 16,
                      bottom: 8,
                    ),
                    child: Text(
                      task.description!,
                      maxLines: _showFullDescription ? null : 2,
                      overflow: _showFullDescription
                          ? null
                          : TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: style,
                    ),
                  ),
                );
              },
            ),
          if (widget.tagColors.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 4),
              child: Row(
                children: widget.tagColors.map((c) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Color(c),
                      shape: BoxShape.circle,
                    ),
                  ),
                )).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
