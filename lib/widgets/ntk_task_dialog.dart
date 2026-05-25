import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';
import 'package:nityk/widgets/widgets.dart';
import 'package:nityk/database/database_helper.dart';
import 'package:nityk/models/models.dart';

class NtkTaskDialog extends StatefulWidget {
  final VoidCallback onClose;
  final Task? task;
  const NtkTaskDialog({super.key, required this.onClose, this.task});
  @override
  State<NtkTaskDialog> createState() => _NtkTaskDialogState();
}

class _NtkTaskDialogState extends State<NtkTaskDialog> {
  final _titleController = TextEditingController();
  final _titleFocus = FocusNode();
  final _descController = TextEditingController();
  final _descFocus = FocusNode();
  final _dateController = TextEditingController();
  final _dateFocus = FocusNode();
  int _priority = 2;

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    if (t != null) {
      _titleController.text = t.title;
      _descController.text = t.description ?? '';
      _priority = t.priority;
      if (t.dueDate != null) {
        _dateController.text =
            '${t.dueDate!.day.toString().padLeft(2, '0')}-'
            '${t.dueDate!.month.toString().padLeft(2, '0')}-'
            '${t.dueDate!.year}';
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocus.dispose();
    _descController.dispose();
    _descFocus.dispose();
    _dateController.dispose();
    _dateFocus.dispose();
    super.dispose();
  }

  Color _priorityColor(int p) => switch (p) {
    1 => NtkColors.priorityHigh,
    3 => NtkColors.priorityLow,
    _ => NtkColors.priorityMedium,
  };

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    DateTime? dueDate;
    if (_dateController.text.trim().isNotEmpty) {
      final parts = _dateController.text.trim().split('-');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (day != null && month != null && year != null) {
          dueDate = DateTime(year, month, day);
        }
      }
    }
    final t = widget.task;
    if (t != null) {
      await DatabaseHelper.instance.updateTask(
        t.copyWith(
          title: title,
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          priority: _priority,
          dueDate: dueDate,
        ),
      );
    } else {
      final task = Task(
        title: title,
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        priority: _priority,
        dueDate: dueDate,
      );
      await DatabaseHelper.instance.insertTask(task);
    }
    widget.onClose();
  }

  Future<void> _delete() async {
    final id = widget.task?.id;
    if (id != null) {
      await DatabaseHelper.instance.deleteTask(id);
    }
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onClose,
          child: Container(color: NtkColors.scrim),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 60),
            curve: Curves.linear,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: NtkColors.surface,
                  border: NtkColors.standardBorder,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEditing ? 'Edit Task' : 'Add Task',
                      style: NtkText.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    NtkTextField(
                      controller: _titleController,
                      focusNode: _titleFocus,
                      hint: 'Task title',
                    ),
                    const SizedBox(height: 12),
                    NtkTextField(
                      controller: _descController,
                      focusNode: _descFocus,
                      hint: 'Description',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        for (final p in [('H', 1), ('M', 2), ('L', 3)]) ...[
                          if (p.$2 > 1) const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _priority = p.$2),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _priority == p.$2
                                      ? _priorityColor(p.$2)
                                      : NtkColors.surfaceHigh,
                                ),
                                child: Text(
                                  p.$1,
                                  style: NtkText.titleLarge.copyWith(
                                    color: _priority == p.$2
                                        ? NtkColors.onAccent
                                        : NtkColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    NtkTextField(
                      controller: _dateController,
                      focusNode: _dateFocus,
                      hint: 'DD-MM-YYYY',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: widget.onClose,
                            child: Container(
                              height: 44,
                              alignment: Alignment.center,
                              child: Text(
                                'Cancel',
                                style: NtkText.labelLarge.copyWith(
                                  color: NtkColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (isEditing) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: _delete,
                              child: Container(
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: NtkColors.deleteButt,
                                ),
                                child: Text(
                                  'Delete',
                                  style: NtkText.labelLarge.copyWith(
                                    color: NtkColors.onAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: _save,
                            child: Container(
                              height: 44,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: NtkColors.accentContainerLight,
                              ),
                              child: Text(
                                'Save',
                                style: NtkText.labelLarge.copyWith(
                                  color: NtkColors.onAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
