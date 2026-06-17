import 'package:flutter/widgets.dart';
import 'ntk_text_field.dart';
import 'ntk_tag_chip.dart';
import 'ntk_tag_picker.dart';
import 'ntk_base_dialog.dart';
import '../theme/theme.dart';
import '../database/database_helper.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../utils/utils.dart';

class NtkLogDialog extends StatefulWidget {
  final Log? log;
  final bool isTimer;
  final VoidCallback onClose;
  const NtkLogDialog({
    super.key,
    this.log,
    this.isTimer = false,
    required this.onClose,
  });
  @override
  State<NtkLogDialog> createState() => _NtkLogDialogState();
}

class _NtkLogDialogState extends State<NtkLogDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _finishTimeController = TextEditingController();
  final _titleFocus = FocusNode();
  final _descFocus = FocusNode();
  final _dateFocus = FocusNode();
  final _startFocus = FocusNode();
  final _finishFocus = FocusNode();
  String? _error;
  int _activeTab = 0;
  List<int> _selectedTagIds = [];

  bool get isNewTimer => widget.log == null && _activeTab == 0;
  bool get isManual => widget.log == null && _activeTab == 1;
  bool get isEditing => widget.log != null;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.isTimer ? 0 : 1;
    if (isEditing) {
      final l = widget.log!;
      _titleController.text = l.title;
      _descController.text = l.description;
      _dateController.text = DateTimeUtils.dateDisplay(l.date);
      if (l.startedAt != null) {
        final h = l.startedAt!.hour.toString().padLeft(2, '0');
        final m = l.startedAt!.minute.toString().padLeft(2, '0');
        _startTimeController.text = '$h:$m';
      }
      if (l.finishedAt != null) {
        final h = l.finishedAt!.hour.toString().padLeft(2, '0');
        final m = l.finishedAt!.minute.toString().padLeft(2, '0');
        _finishTimeController.text = '$h:$m';
      }
    } else if (isManual) {
      _dateController.text = DateTimeUtils.date();
    }
    if (isEditing) {
      DatabaseHelper.instance.getLogTagIds(widget.log!.id!).then((ids) {
        if (mounted) setState(() => _selectedTagIds = ids);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _finishTimeController.dispose();
    _titleFocus.dispose();
    _descFocus.dispose();
    _dateFocus.dispose();
    _startFocus.dispose();
    _finishFocus.dispose();
    super.dispose();
  }

  Future<void> _startTimer() async {
    try {
      final title = _titleController.text.trim();
      if (title.isEmpty) {
        setState(() => _error = 'Title is required');
        return;
      }
      if (!LogTimerService.instance.canStart) {
        setState(() => _error = 'Max 3 timers running');
        return;
      }
      final now = DateTime.now();
      final today = DateTimeUtils.date();
      final log = Log(
        title: title,
        description: _descController.text.trim(),
        date: today,
        startedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      final id = await LogService.instance.create(log);
      if (_selectedTagIds.isNotEmpty) {
        await DatabaseHelper.instance.setLogTags(id, _selectedTagIds);
      }
      LogTimerService.instance.start(id, title);
      widget.onClose();
    } catch (e) {
      if (mounted) setState(() => _error = 'Failed to start timer');
    }
  }

  Future<void> _save() async {
    try {
      final title = _titleController.text.trim();
      if (title.isEmpty) {
        setState(() => _error = 'Title is required');
        return;
      }
      if (_dateController.text.trim().isEmpty) {
        _dateController.text = DateTimeUtils.dateDisplay(DateTimeUtils.date());
      }
      final startMin = _startTimeController.text.trim().isEmpty
          ? null
          : DateTimeUtils.parseTime(_startTimeController.text.trim());
      final finishMin = _finishTimeController.text.trim().isEmpty
          ? null
          : DateTimeUtils.parseTime(_finishTimeController.text.trim());
      if (_startTimeController.text.trim().isNotEmpty && startMin == null) {
        setState(() => _error = 'Invalid start time (use HH:MM)');
        return;
      }
      if (_finishTimeController.text.trim().isNotEmpty && finishMin == null) {
        setState(() => _error = 'Invalid finish time (use HH:MM)');
        return;
      }
      if (startMin != null && finishMin == null) {
        setState(
          () => _error = 'Finish time is required when start time is set',
        );
        return;
      }
      final now = DateTime.now();
      DateTime? startedDt;
      DateTime? finishedDt;
      if (startMin != null && finishMin != null) {
        final dateParts = _dateController.text.trim().split('-');
        int day, month, year;
        try {
          day = int.parse(dateParts[0]);
          month = int.parse(dateParts[1]);
          year = int.parse(dateParts[2]);
        } catch (_) {
          setState(() => _error = 'Invalid date (use DD-MM-YYYY)');
          return;
        }
        startedDt = DateTime(year, month, day, startMin ~/ 60, startMin % 60);
        finishedDt = DateTime(
          year,
          month,
          day,
          finishMin ~/ 60,
          finishMin % 60,
        );
      }
      final durationSeconds = startedDt != null && finishedDt != null
          ? finishedDt.difference(startedDt).inSeconds
          : null;
      final log = Log(
        id: isEditing ? widget.log!.id : null,
        title: title,
        description: _descController.text.trim(),
        date: DateTimeUtils.dateParse(_dateController.text.trim()),
        startedAt: startedDt,
        finishedAt: finishedDt,
        durationSeconds: durationSeconds,
        createdAt: isEditing ? widget.log!.createdAt : now,
        updatedAt: now,
      );
      if (isEditing) {
        await LogService.instance.update(log);
        await DatabaseHelper.instance.setLogTags(
          widget.log!.id!,
          _selectedTagIds,
        );
      } else {
        final id = await LogService.instance.create(log);
        if (_selectedTagIds.isNotEmpty) {
          await DatabaseHelper.instance.setLogTags(id, _selectedTagIds);
        }
      }
      widget.onClose();
    } catch (e) {
      if (mounted) setState(() => _error = 'Failed to save log');
    }
  }

  Future<void> _delete() async {
    final id = widget.log?.id;
    if (id != null) {
      await LogService.instance.delete(id);
    }
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final title = isEditing
        ? 'Edit Log'
        : _activeTab == 0
        ? 'New Log (Timer)'
        : 'New Log (Manual)';
    final canStart = LogTimerService.instance.canStart;
    return NtkBaseDialog(
      onClose: widget.onClose,
      title: title,
      onSave: isNewTimer ? _startTimer : _save,
      saveLabel: isNewTimer ? 'Start' : 'Save',
      saveColor: isNewTimer && !canStart ? NtkColors.textDisabled : null,
      onDelete: isEditing ? _delete : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isEditing) ...[
            Row(
              children: [
                for (final entry in [('Timer', 0), ('Manual', 1)]) ...[
                  if (entry.$2 > 0) const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _activeTab = entry.$2),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _activeTab == entry.$2
                              ? NtkColors.accentContainerLight
                              : NtkColors.surfaceHigh,
                        ),
                        child: Text(
                          entry.$1,
                          style: NtkText.titleLarge.copyWith(
                            color: _activeTab == entry.$2
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
            const SizedBox(height: 16),
          ],
          NtkTextField(
            controller: _titleController,
            focusNode: _titleFocus,
            hint: 'Title',
          ),
          const SizedBox(height: 12),
          NtkTextField(
            controller: _descController,
            focusNode: _descFocus,
            hint: 'Description',
            maxLines: 3,
          ),
          if (isEditing || isManual) ...[
            const SizedBox(height: 12),
            NtkTextField(
              controller: _dateController,
              focusNode: _dateFocus,
              hint: 'DD-MM-YYYY',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: NtkTextField(
                    controller: _startTimeController,
                    focusNode: _startFocus,
                    hint: 'Start (HH:MM)',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('-', style: NtkText.bodyLarge),
                ),
                Expanded(
                  child: NtkTextField(
                    controller: _finishTimeController,
                    focusNode: _finishFocus,
                    hint: 'Finish (HH:MM)',
                  ),
                ),
              ],
            ),
          ],
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
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: NtkText.bodySmall.copyWith(color: NtkColors.error),
            ),
          ],
        ],
      ),
    );
  }
}
