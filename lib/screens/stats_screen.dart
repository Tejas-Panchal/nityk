import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

class StatsScreen extends StatelessWidget {
  final void Function(Widget) push;
  const StatsScreen({super.key, required this.push});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Stats', style: NtkText.headlineLarge));
  }
}
