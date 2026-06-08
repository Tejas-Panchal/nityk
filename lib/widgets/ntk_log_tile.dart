import 'dart:async';
import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import '../widgets/ntk_icon.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class NtkLogTile extends StatefulWidget {
  final Log log;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const NtkLogTile({super.key, required this.log, this.onEdit, this.onDelete});

  @override
  State<NtkLogTile> createState() => _NtkLogTileState();
}

class _NtkLogTileState extends State<NtkLogTile> {
  bool _showActions = false;
  Timer? _hideTimer;
  bool _showFullDescription = false;

  void _showActionsForAWhile() {
    _hideTimer?.cancel();
    setState(() => _showActions = true);
    _hideTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) setState(() => _showActions = false);
    });
  }

  void _hideActionsNow() {
    _hideTimer?.cancel();
    setState(() => _showActions = false);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  String get _timeDisplay {
    final started = widget.log.startedAt;
    final finished = widget.log.finishedAt;

    String fmt(DateTime dt) {
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }

    String? durationStr;
    if (widget.log.durationSeconds != null) {
      durationStr = DateTimeUtils.formatDuration(
        Duration(seconds: widget.log.durationSeconds!),
      );
    }

    final timePart = started != null && finished != null
        ? '${fmt(started)}-${fmt(finished)}${durationStr != null ? '[$durationStr]' : ''}'
        : finished != null
        ? '-${fmt(finished)}'
        : '';

    return timePart;
  }

  @override
  Widget build(BuildContext context) {
    final log = widget.log;
    final timeStr = _timeDisplay;

    return Container(
      decoration: BoxDecoration(
        color: NtkColors.surface,
        border: Border(bottom: BorderSide(color: NtkColors.border, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 48,
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _showActionsForAWhile,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(log.title, style: NtkText.headlineMedium),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _showActionsForAWhile,
                    child: Container(
                      height: 48,
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_showActions) ...[
                            GestureDetector(
                              onTap: () {
                                _hideActionsNow();
                                widget.onEdit?.call();
                              },
                              child: const NtkIcon(
                                icon: NtkIcons.edit,
                                size: 24,
                                color: NtkColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                _hideActionsNow();
                                widget.onDelete?.call();
                              },
                              child: const NtkIcon(
                                icon: NtkIcons.delete,
                                size: 24,
                                color: NtkColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                          if (timeStr.isNotEmpty && !_showActions)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                timeStr,
                                style: NtkText.labelSmall.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (log.description.isNotEmpty)
            LayoutBuilder(
              builder: (context, constraints) {
                final style = NtkText.bodyMedium.copyWith(
                  color: NtkColors.textSecondary,
                );
                final tp = TextPainter(
                  text: TextSpan(text: log.description, style: style),
                  maxLines: 2,
                  textDirection: TextDirection.ltr,
                )..layout(maxWidth: constraints.maxWidth);
                return GestureDetector(
                  onTap: tp.didExceedMaxLines
                      ? () => setState(
                          () => _showFullDescription = !_showFullDescription,
                        )
                      : null,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 16,
                      bottom: 8,
                    ),
                    child: Text(
                      log.description,
                      maxLines: _showFullDescription ? null : 2,
                      overflow: _showFullDescription
                          ? null
                          : TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: style,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
