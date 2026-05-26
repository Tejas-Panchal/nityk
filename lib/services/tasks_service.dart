import 'package:flutter/widgets.dart';
import '../models/models.dart';
import '../database/database_helper.dart';

class TaskService extends ChangeNotifier {
  static final TaskService instance = TaskService._();
  TaskService._();
  List<Task> _tasks = [];
  List<Task> get tasks => List.unmodifiable(_tasks);
  List<Task> get incompleteTasks =>
      _tasks.where((t) => !t.isCompleted).toList();
  List<Task> get completedTasks => _tasks.where((t) => t.isCompleted).toList();
  Future<void> load() async {
    _tasks = await DatabaseHelper.instance.getAllTasks();
    notifyListeners();
  }

  Future<void> add(Task task) async {
    await DatabaseHelper.instance.insertTask(task);
    await load();
  }

  Future<void> update(Task task) async {
    await DatabaseHelper.instance.updateTask(task);
    await load();
  }

  Future<void> delete(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    await load();
  }

  Future<void> toggleComplete(int id) async {
    await DatabaseHelper.instance.toggleComplete(id);
    await load();
  }
}
