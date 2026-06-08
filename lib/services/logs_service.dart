import 'package:flutter/widgets.dart';
import '../database/database_helper.dart';
import '../models/models.dart';

class LogService extends ChangeNotifier {
  static final LogService instance = LogService._();
  LogService._();
  List<Log> _logs = [];
  List<Log> get allLogs => List.unmodifiable(_logs);

  /// Logs that are currently running (startedAt set, finishedAt null)
  List<Log> get activeLogs =>
      _logs.where((l) => l.startedAt != null && l.finishedAt == null).toList();
  Future<void> load() async {
    _logs = await DatabaseHelper.instance.getAllLogs();
    notifyListeners();
  }

  Future<void> create(Log log) async {
    await DatabaseHelper.instance.insertLog(log);
    await load();
  }

  Future<void> update(Log log) async {
    await DatabaseHelper.instance.updateLog(log);
    await load();
  }

  Future<void> delete(int id) async {
    await DatabaseHelper.instance.deleteLog(id);
    await load();
  }

  /// Convenience: stop a running timer
  Future<void> stopTimer(int logId) async {
    final idx = _logs.indexWhere((l) => l.id == logId);
    if (idx == -1) return;
    final log = _logs[idx];
    final now = DateTime.now();
    final updated = log.copyWith(
      finishedAt: now,
      durationSeconds: log.startedAt != null
          ? now.difference(log.startedAt!).inSeconds
          : null,
      updatedAt: now,
    );
    await update(updated);
  }
}
