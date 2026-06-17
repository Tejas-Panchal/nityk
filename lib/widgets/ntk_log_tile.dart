import 'package:flutter/widgets.dart';
import 'ntk_base_tile.dart';
import '../theme/theme.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class NtkLogTile extends StatelessWidget {
  final Log log;
  final List<int> tagColors;

  const NtkLogTile({
    super.key,
    required this.log,
    this.tagColors = const [],
  });

  String get _timeDisplay {
    final started = log.startedAt;
    final finished = log.finishedAt;

    String fmt(DateTime dt) {
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }

    String? durationStr;
    if (log.durationSeconds != null) {
      durationStr = DateTimeUtils.formatDuration(
        Duration(seconds: log.durationSeconds!),
      );
    }

    return started != null && finished != null
        ? '${fmt(started)}-${fmt(finished)}${durationStr != null ? '[$durationStr]' : ''}'
        : finished != null
        ? '-${fmt(finished)}'
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return NtkBaseTile(
      tagColors: tagColors,
      tagPaddingLeft: 8,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(log.title, style: NtkText.headlineMedium),
      ),
      trailing: _timeDisplay.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                _timeDisplay,
                style: NtkText.labelSmall.copyWith(fontSize: 14),
              ),
            )
          : null,
    );
  }
}
