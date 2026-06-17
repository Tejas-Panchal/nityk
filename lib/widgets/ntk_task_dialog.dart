import 'package:flutter/widgets.dart';
import 'ntk_text_field.dart';
import 'ntk_tag_chip.dart';
import 'ntk_tag_picker.dart';
import 'ntk_base_dialog.dart';
import '../theme/theme.dart';
import '../database/database_helper.dart';
import '../services/services.dart';
import '../models/models.dart';

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
  List<int> _selectedTagIds = [];

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
      if (t.id != null) {
        DatabaseHelper.instance.getTaskTagIds(t.id!).then((ids) {
          if (mounted) setState(() => _selectedTagIds = ids);
        });
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
      await TaskService.instance.update(
        t.copyWith(
          title: title,
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          priority: _priority,
          dueDate: dueDate,
          clearDescription: _descController.text.trim().isEmpty,
          clearDueDate: dueDate == null,
        ),
      );
      await DatabaseHelper.instance.setTaskTags(t.id!, _selectedTagIds);
    } else {
      final task = Task(
        title: title,
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        priority: _priority,
        dueDate: dueDate,
      );
      final id = await TaskService.instance.add(task);
      if (_selectedTagIds.isNotEmpty) {
        await DatabaseHelper.instance.setTaskTags(id, _selectedTagIds);
      }
    }
    widget.onClose();
  }

  Future<void> _delete() async {
    final id = widget.task?.id;
    if (id != null) {
      await TaskService.instance.delete(id);
    }
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    return NtkBaseDialog(
      onClose: widget.onClose,
      title: isEditing ? 'Edit Task' : 'Add Task',
      onSave: _save,
      onDelete: isEditing ? _delete : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Tags', style: NtkText.labelLarge),
              const Spacer(),
              ..._selectedTagIds.map((id) {
                final tag = TagService.instance.tags.firstWhere(
                  (t) => t.id == id,
                  orElse: () => Tag(name: '', categoryId: 0),
                );
                final cat = CategoryService.instance.categories.firstWhere(
                  (c) => c.id == tag.categoryId,
                  orElse: () => Category(name: '', color: 0),
                );
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: NtkTagChip(color: cat.color),
                );
              }),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      barrierDismissible: true,
                      barrierColor: NtkColors.scrim,
                      pageBuilder: (_, _, _) => NtkTagPicker(
                        selectedTagIds: _selectedTagIds,
                        onConfirm: (ids) {
                          setState(() => _selectedTagIds = ids);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: NtkColors.border),
                  ),
                  child: Text('Select', style: NtkText.bodySmall),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
