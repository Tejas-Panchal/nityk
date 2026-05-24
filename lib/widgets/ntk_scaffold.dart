import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import 'ntk_app_bar.dart';
import 'ntk_bottom_nav.dart';

class NtkScaffold extends StatelessWidget {
  final NtkAppBar? appBar;
  final Widget body;
  final NtkBottomNav? bottomNav;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  const NtkScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNav,
    this.backgroundColor,
    this.floatingActionButton,
  });
  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        ?appBar,
        Expanded(child: body),
        ?bottomNav,
      ],
    );
    if (floatingActionButton != null) {
      content = Stack(
        children: [
          content,
          Positioned(
            right: 16,
            bottom: (bottomNav != null ? 80 : 16),
            child: floatingActionButton!,
          ),
        ],
      );
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor ?? NtkColors.background,
      child: content,
    );
  }
}
