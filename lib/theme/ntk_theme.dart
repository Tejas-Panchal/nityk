import 'package:flutter/widgets.dart';
import 'ntk_colors.dart';
import 'ntk_text.dart';

class NtkTheme extends InheritedWidget {
  final NtkColors colors;
  final NtkText text;
  const NtkTheme({
    super.key,
    required super.child,
    this.colors = const NtkColors(),
    this.text = const NtkText(),
  });
  static NtkTheme of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<NtkTheme>();
    assert(result != null, 'No NtkTheme found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(NtkTheme oldWidget) =>
      oldWidget.colors != colors || oldWidget.text != text;
}
