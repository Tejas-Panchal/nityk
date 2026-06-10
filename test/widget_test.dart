import 'package:flutter_test/flutter_test.dart';

import 'package:nityk/utils/utils.dart';

void main() {
  group('DateTimeUtils', () {
    test('date returns YYYYMMDD format', () {
      final d = DateTimeUtils.date();
      expect(d, matches(RegExp(r'^\d{8}$')));
    });

    test('dateDisplay converts YYYYMMDD to DD-MM-YYYY', () {
      expect(DateTimeUtils.dateDisplay('20260610'), '10-06-2026');
      expect(DateTimeUtils.dateDisplay('20251225'), '25-12-2025');
      expect(DateTimeUtils.dateDisplay('short'), 'short');
    });

    test('dateParse converts DD-MM-YYYY to YYYYMMDD', () {
      expect(DateTimeUtils.dateParse('10-06-2026'), '20260610');
      expect(DateTimeUtils.dateParse('25-12-2025'), '20251225');
    });

    test('formatDuration handles hours and minutes', () {
      expect(DateTimeUtils.formatDuration(const Duration(hours: 2, minutes: 15)),
          '2h15m');
      expect(DateTimeUtils.formatDuration(const Duration(minutes: 5)), '5m');
    });

    test('parseTime returns minutes from midnight', () {
      expect(DateTimeUtils.parseTime('14:30'), 870);
      expect(DateTimeUtils.parseTime('invalid'), isNull);
    });
  });
}
