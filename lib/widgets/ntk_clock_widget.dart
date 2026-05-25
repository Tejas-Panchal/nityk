import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';
import 'package:nityk/utils/utils.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({super.key});
  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(DateTimeUtils.time(), style: NtkText.headlineMedium),
      ),
    );
  }
}
