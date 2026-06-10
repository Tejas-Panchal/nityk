import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

class HabitsScreen extends StatelessWidget {
  final void Function(Widget) push;
  const HabitsScreen({super.key, required this.push});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Habits', style: NtkText.headlineLarge));
  }
}
