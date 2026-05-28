import 'package:flutter/widgets.dart';

class ActiveTimer {
  final int logId;
  final String title;
  final DateTime startedAt;
  const ActiveTimer({
    required this.logId,
    required this.title,
    required this.startedAt,
  });

  Duration get elapsed => DateTime.now().difference(startedAt);
}

class LogTimerService extends ChangeNotifier {
  static final LogTimerService instance = LogTimerService._();
  LogTimerService._();
  final List<ActiveTimer> _timers = [];
  bool get canStart => _timers.length < 3;
  List<ActiveTimer> get timers => List.unmodifiable(_timers);

  double get bottomPillPadding {
    if (_timers.isEmpty) return 44;
    const pillHeight = 36.0;
    const pillGap = 8.0;
    const bottomOffset = 64.0;
    final n = _timers.length;
    return bottomOffset + (n - 1) * (pillHeight + pillGap) + pillHeight + 16;
  }

  void start(int logId, String title, {DateTime? startedAt}) {
    if (!canStart) return;
    _timers.add(
      ActiveTimer(
        logId: logId,
        title: title,
        startedAt: startedAt ?? DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void stop(int logId) {
    _timers.removeWhere((t) => t.logId == logId);
    notifyListeners();
  }

  bool isRunning(int logId) => _timers.any((t) => t.logId == logId);
}
