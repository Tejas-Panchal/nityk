import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

class StatsScreen extends StatefulWidget {
  final void Function(Widget) push;
  const StatsScreen({super.key, required this.push});
  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Stats', style: NtkText.headlineLarge));
  }
}
