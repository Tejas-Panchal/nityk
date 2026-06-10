import 'package:flutter/widgets.dart';
import '../utils/utils.dart';

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
    final n = _timers.length;
    final rows = n == 3 ? 2 : 1;
    final pillH = n == 3 ? 44 : AppConstants.pillHeight;
    final height = rows * pillH + (rows - 1) * AppConstants.pillGap;
    return AppConstants.pillPaddingOffset + height + 16;
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
