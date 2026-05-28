import 'dart:async';
import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

class NtkLogTimerPill extends StatefulWidget {
  final String title;
  final DateTime startedAt;
  final VoidCallback onStop;

  const NtkLogTimerPill({
    super.key,
    required this.title,
    required this.startedAt,
    required this.onStop,
  });

  @override
  State<NtkLogTimerPill> createState() => _NtkLogTimerPillState();
}

class _NtkLogTimerPillState extends State<NtkLogTimerPill> {
  Timer? _timer;
  Timer? _confirmTimer;
  Duration _elapsed = Duration.zero;
  bool _showStopConfirm = false;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!mounted) return;
    setState(() => _elapsed = DateTime.now().difference(widget.startedAt));
  }

  void _onTap() {
    if (_showStopConfirm) {
      _confirmTimer?.cancel();
      widget.onStop();
      return;
    }
    _confirmTimer?.cancel();
    setState(() => _showStopConfirm = true);
    _confirmTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) setState(() => _showStopConfirm = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confirmTimer?.cancel();
    super.dispose();
  }

  String get _display {
    if (_showStopConfirm) return 'Stop?';
    final initial = widget.title.trim().isNotEmpty
        ? widget.title.trim()[0].toUpperCase()
        : '?';
    final h = _elapsed.inHours;
    final m = _elapsed.inMinutes.remainder(60);
    final s = _elapsed.inSeconds.remainder(60);
    final time = h > 0
        ? '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}'
        : '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return '[$initial] $time';
  }

  @override
  Widget build(BuildContext context) {
    final h = _elapsed.inHours;
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: _showStopConfirm
              ? NtkColors.priorityHighDark
              : NtkColors.surfaceHigh,
          border: Border.all(
            color: _showStopConfirm
                ? NtkColors.priorityHighDark
                : NtkColors.border,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: SizedBox(
          width: h > 0 ? 76 : 60,
          child: Text(
            _display,
            textAlign: TextAlign.center,
            style: NtkText.labelLarge.copyWith(
              fontSize: 16,
              color: _showStopConfirm
                  ? NtkColors.onAccent
                  : NtkColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
