import 'package:flutter/widgets.dart';
import '../models/models.dart';
import '../database/database_helper.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService instance = SettingsService._();
  SettingsService._();
  Settings _settings = const Settings();
  String get sortOrder => _settings.sortOrder;
  bool get darkMode => _settings.darkMode;
  bool get use24h => _settings.use24h;

  set sortOrder(String v) {
    _settings = _settings.copyWith(sortOrder: v);
    notifyListeners();
    DatabaseHelper.instance.saveSettings(_settings);
  }

  set darkMode(bool v) {
    _settings = _settings.copyWith(darkMode: v);
    notifyListeners();
    DatabaseHelper.instance.saveSettings(_settings);
  }

  set use24h(bool v) {
    _settings = _settings.copyWith(use24h: v);
    notifyListeners();
    DatabaseHelper.instance.saveSettings(_settings);
  }

  Future<void> load() async {
    _settings = await DatabaseHelper.instance.getSettings();
    notifyListeners();
  }
}
