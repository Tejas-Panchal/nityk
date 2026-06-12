import 'package:flutter/widgets.dart';
import '../database/database_helper.dart';
import '../models/models.dart';

class CategoryService extends ChangeNotifier {
  static final CategoryService instance = CategoryService._();
  CategoryService._();

  List<Category> _categories = [];
  List<Category> get categories => List.unmodifiable(_categories);

  Future<void> load() async {
    _categories = await DatabaseHelper.instance.getAllCategories();
    notifyListeners();
  }

  Future<void> create(Category cat) async {
    await DatabaseHelper.instance.insertCategory(cat);
    await load();
  }

  Future<void> update(Category cat) async {
    await DatabaseHelper.instance.updateCategory(cat);
    await load();
  }

  Future<void> delete(int id) async {
    await DatabaseHelper.instance.deleteCategory(id);
    await load();
  }
}
