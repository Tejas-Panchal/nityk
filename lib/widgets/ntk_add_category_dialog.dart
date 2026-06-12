import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../utils/utils.dart';
import 'ntk_dialog_base.dart';

class NtkAddCategoryDialog extends StatefulWidget {
  final VoidCallback onClose;
  const NtkAddCategoryDialog({super.key, required this.onClose});
  @override
  State<NtkAddCategoryDialog> createState() => _NtkAddCategoryDialogState();
}

class _NtkAddCategoryDialogState extends State<NtkAddCategoryDialog> {
  final _nameCtrl = TextEditingController();
  final _focus = FocusNode();
  int _selectedColor = AppConstants.categoryColors[0];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    await CategoryService.instance.create(
      Category(name: name, color: _selectedColor),
    );
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return NtkDialogBase(
      onClose: widget.onClose,
      title: 'New Category',
      onSave: _save,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            color: NtkColors.surfaceHigh,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: EditableText(
              controller: _nameCtrl,
              focusNode: _focus,
              style: NtkText.bodyLarge,
              cursorColor: NtkColors.accent,
              backgroundCursorColor: NtkColors.textDisabled,
            ),
          ),
          const SizedBox(height: 16),
          Text('Color', style: NtkText.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.categoryColors.map((c) {
              final isSel = c == _selectedColor;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = c),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Color(c),
                    shape: BoxShape.circle,
                    border: isSel
                        ? Border.all(color: NtkColors.onAccent, width: 3)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
