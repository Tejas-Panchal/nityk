import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';

class HabitsScreen extends StatefulWidget {
  final void Function(Widget) push;
  const HabitsScreen({super.key, required this.push});
  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Habits', style: NtkText.headlineLarge));
  }
}
