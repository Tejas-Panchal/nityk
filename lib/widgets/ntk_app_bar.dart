import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

class NtkAppBar extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final List<Widget> actions;
  final Color? backgroundColor;
  final double height;
  const NtkAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions = const [],
    this.backgroundColor,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      height: height + topPadding,
      padding: EdgeInsets.only(top: topPadding),
      color: backgroundColor ?? NtkColors.accentContainer,
      child: Stack(
        children: [
          // Title — truly centered
          Positioned.fill(
            child: Center(child: title ?? const SizedBox.shrink()),
          ),
          // Leading — pinned left
          Positioned(
            left: 4,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: 120,
              child: leading ?? const SizedBox.shrink(),
            ),
          ),
          // Actions — pinned right
          Positioned(
            right: 4,
            top: 0,
            bottom: 0,
            child: Row(mainAxisSize: MainAxisSize.min, children: actions),
          ),
        ],
      ),
    );
  }
}
