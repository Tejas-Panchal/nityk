import 'dart:async';

class DateTimeUtils {
  /// Current time in HH:MM:SS (24h)
  static String time({bool showSeconds = true}) {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    final s = now.second.toString().padLeft(2, '0');
    return showSeconds ? '$h:$m:$s' : '$h:$m';
  }

  /// Current time in hh:MM AM/PM (12h)
  static String time12h({bool showSeconds = false}) {
    final now = DateTime.now();
    final h = (now.hour == 0 ? 12 : (now.hour > 12 ? now.hour - 12 : now.hour))
        .toString()
        .padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    final s = now.second.toString().padLeft(2, '0');
    final ampm = now.hour < 12 ? 'AM' : 'PM';
    final time = showSeconds ? '$h:$m:$s' : '$h:$m';
    return '$time $ampm';
  }

  /// Current date in "Mon, 25 May 2026"
  static String dateFull() {
    final now = DateTime.now();
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[now.weekday % 7]}, '
        '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  /// Current day name: "Monday"
  static String day() {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[DateTime.now().weekday - 1];
  }

  /// Current day short: "Mon"
  static String dayShort() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[DateTime.now().weekday - 1];
  }

  /// Current date in any format with custom separator
  static String dateFormat({String separator = '-'}) {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}$separator'
        '${now.month.toString().padLeft(2, '0')}$separator'
        '${now.year}';
  }

  /// All-in-one: "Monday, 25-05-2026 14:30:15"
  static String full() {
    return '${day()}, ${date()} ${time()}';
  }

  /// Returns a stream that ticks every second
  static Stream<DateTime> tick() {
    return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
  }

  /// Parse "HH:MM" to minutes from midnight. Returns null if invalid.
  static int? parseTime(String value) {
    final parts = value.trim().split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) {
      return null;
    }
    return h * 60 + m;
  }

  /// Format minutes from midnight as "HH:MM"
  static String formatTime(int minutes) {
    final h = (minutes ~/ 60).toString().padLeft(2, '0');
    final m = (minutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Format a Duration as "XhYm" or just "Ym"
  static String formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h > 0) return '${h}h${m}m';
    return '${m}m';
  }

  /// Storage format: YYYYMMDD (lexicographically sortable)
  static String date() {
    final now = DateTime.now();
    return '${now.year}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}';
  }

  /// Display format: DD-MM-YYYY from storage string
  static String dateDisplay(String storage) {
    if (storage.length != 8) return storage;
    return '${storage.substring(6, 8)}-'
        '${storage.substring(4, 6)}-'
        '${storage.substring(0, 4)}';
  }

  /// Parse display string (DD-MM-YYYY) back to storage (YYYYMMDD)
  static String dateParse(String display) {
    final parts = display.split('-');
    if (parts.length != 3) return display;
    return '${parts[2]}${parts[1]}${parts[0]}';
  }
}
