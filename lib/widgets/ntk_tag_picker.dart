import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import 'widgets.dart';
import '../services/services.dart';

class NtkTagPicker extends StatefulWidget {
  final List<int> selectedTagIds;
  final ValueChanged<List<int>> onConfirm;

  const NtkTagPicker({
    super.key,
    required this.selectedTagIds,
    required this.onConfirm,
  });

  @override
  State<NtkTagPicker> createState() => _NtkTagPickerState();
}

class _NtkTagPickerState extends State<NtkTagPicker> {
  late Set<int> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selectedTagIds);
  }

  @override
  Widget build(BuildContext context) {
    final categories = CategoryService.instance.categories;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tags', style: NtkText.headlineMedium),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: categories.map((cat) {
                final tags = TagService.instance.tagsByCategory(cat.id!);
                if (tags.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        NtkTagChip(color: cat.color, size: 12),
                        const SizedBox(width: 8),
                        Text(cat.name, style: NtkText.labelLarge),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: tags.map((tag) {
                        final isSel = _selected.contains(tag.id);
                        return GestureDetector(
                          onTap: () => setState(() {
                            if (isSel) {
                              _selected.remove(tag.id);
                            } else {
                              _selected.add(tag.id!);
                            }
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? Color(cat.color).withAlpha(77)
                                  : NtkColors.surfaceHigh,
                              border: Border.all(
                                color: isSel
                                    ? Color(cat.color)
                                    : NtkColors.border,
                              ),
                            ),
                            child: Text(
                              tag.name,
                              style: NtkText.bodyMedium.copyWith(
                                color: isSel
                                    ? Color(cat.color)
                                    : NtkColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => widget.onConfirm(_selected.toList()),
            child: Container(
              width: double.infinity,
              height: 48,
              color: NtkColors.accent,
              alignment: Alignment.center,
              child: Text(
                'Apply',
                style: NtkText.labelLarge.copyWith(color: NtkColors.onAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
