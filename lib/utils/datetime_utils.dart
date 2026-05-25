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

  /// Current date in DD-MM-YYYY (app standard)
  static String date() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year}';
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
}
