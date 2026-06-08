import 'package:flutter_test/flutter_test.dart';

import 'package:nityk/utils/utils.dart';

void main() {
  group('DateTimeUtils', () {
    test('date returns DD-MM-YYYY format', () {
      final d = DateTimeUtils.date();
      expect(d, matches(RegExp(r'^\d{2}-\d{2}-\d{4}$')));
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
