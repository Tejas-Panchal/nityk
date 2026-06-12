import 'package:flutter/widgets.dart';
import '../database/database_helper.dart';
import '../models/models.dart';

class TagService extends ChangeNotifier {
  static final TagService instance = TagService._();
  TagService._();

  List<Tag> _tags = [];
  List<Tag> get tags => List.unmodifiable(_tags);

  List<Tag> tagsByCategory(int categoryId) =>
      _tags.where((t) => t.categoryId == categoryId).toList();

  Future<void> load() async {
    final db = DatabaseHelper.instance;
    final allCategories = await db.getAllCategories();
    _tags = [];
    for (final cat in allCategories) {
      _tags.addAll(await db.getTagsByCategory(cat.id!));
    }
    notifyListeners();
  }

  Future<void> create(Tag tag) async {
    await DatabaseHelper.instance.insertTag(tag);
    await load();
  }

  Future<void> update(Tag tag) async {
    await DatabaseHelper.instance.updateTag(tag);
    await load();
  }

  Future<void> delete(int id) async {
    await DatabaseHelper.instance.deleteTag(id);
    await load();
  }

  Future<List<Tag>> getTagsForLog(int logId) async {
    final tagIds = await DatabaseHelper.instance.getLogTagIds(logId);
    return _tags.where((t) => tagIds.contains(t.id)).toList();
  }

  Future<List<Tag>> getTagsForTask(int taskId) async {
    final tagIds = await DatabaseHelper.instance.getTaskTagIds(taskId);
    return _tags.where((t) => tagIds.contains(t.id)).toList();
  }
}
