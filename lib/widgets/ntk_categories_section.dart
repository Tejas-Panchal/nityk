import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'ntk_icon.dart';
import 'ntk_settings_section.dart';
import 'ntk_add_category_dialog.dart';

class NtkCategoriesSection extends StatefulWidget {
  const NtkCategoriesSection({super.key});
  @override
  State<NtkCategoriesSection> createState() => _NtkCategoriesSectionState();
}

class _NtkCategoriesSectionState extends State<NtkCategoriesSection> {
  int _expandedCategoryId = -1;
  int _addingTagCategoryId = -1;
  final _tagNameCtrl = TextEditingController();
  final _tagFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    CategoryService.instance.addListener(_onChanged);
    TagService.instance.addListener(_onChanged);
  }

  @override
  void dispose() {
    CategoryService.instance.removeListener(_onChanged);
    TagService.instance.removeListener(_onChanged);
    _tagNameCtrl.dispose();
    _tagFocus.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  Future<void> _saveTag(int categoryId) async {
    final name = _tagNameCtrl.text.trim();
    if (name.isEmpty) return;
    await TagService.instance.create(Tag(name: name, categoryId: categoryId));
    _tagNameCtrl.clear();
    setState(() => _addingTagCategoryId = -1);
  }

  void _deleteTag(Tag tag) => TagService.instance.delete(tag.id!);
  void _deleteCategory(Category cat) =>
      CategoryService.instance.delete(cat.id!);

  @override
  Widget build(BuildContext context) {
    final categories = CategoryService.instance.categories;
    final children = <Widget>[];

    for (final cat in categories) {
      final isExpanded = _expandedCategoryId == cat.id;
      final tags = TagService.instance.tagsByCategory(cat.id!);
      children.add(
        Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() {
                _expandedCategoryId = isExpanded ? -1 : cat.id!;
              }),
              onLongPress: () => _deleteCategory(cat),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Color(cat.color),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(cat.name, style: NtkText.headlineMedium),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.75 : 0.5,
                      duration: const Duration(milliseconds: 200),
                      child: const NtkIcon(
                        icon: NtkIcons.arrow,
                        size: 16,
                        color: NtkColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded) ...[
              ...tags.map(
                (tag) => Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 24, right: 16),
                  color: NtkColors.surfaceHigh,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(tag.name, style: NtkText.bodyMedium),
                      ),
                      GestureDetector(
                        onTap: () => _deleteTag(tag),
                        child: const NtkIcon(
                          icon: NtkIcons.close,
                          size: 16,
                          color: NtkColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_addingTagCategoryId == cat.id)
                Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 24, right: 16),
                  color: NtkColors.surfaceHigh,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 32,
                          child: EditableText(
                            controller: _tagNameCtrl,
                            focusNode: _tagFocus,
                            style: NtkText.bodyMedium,
                            cursorColor: NtkColors.textSecondary,
                            backgroundCursorColor: NtkColors.textDisabled,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: GestureDetector(
                          onTap: () => _saveTag(cat.id!),
                          child: const NtkIcon(
                            icon: NtkIcons.check,
                            size: 16,
                            color: NtkColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                GestureDetector(
                  onTap: () {
                    _tagNameCtrl.clear();
                    setState(() => _addingTagCategoryId = cat.id!);
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 24),
                    color: NtkColors.surfaceHigh,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '+ Add tag',
                      style: NtkText.bodyMedium.copyWith(
                        color: NtkColors.textSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      );
    }

    children.add(
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              barrierDismissible: true,
              barrierColor: NtkColors.scrim,
              pageBuilder: (_, _, _) => NtkAddCategoryDialog(
                onClose: () => Navigator.of(context).pop(),
              ),
            ),
          );
        },
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const NtkIcon(
                icon: NtkIcons.add,
                size: 20,
                color: NtkColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text('Add Category', style: NtkText.headlineMedium),
            ],
          ),
        ),
      ),
    );

    return NtkSettingsSection(title: 'Categories & Tags', children: children);
  }
}
