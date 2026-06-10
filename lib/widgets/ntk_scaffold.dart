import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import 'ntk_app_bar.dart';
import 'ntk_bottom_nav.dart';

class NtkScaffold extends StatelessWidget {
  final NtkAppBar? appBar;
  final Widget body;
  final NtkBottomNav? bottomNav;
  final Color? backgroundColor;
  const NtkScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNav,
    this.backgroundColor,
  });
  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        ?appBar,
        Expanded(child: body),
        ?bottomNav,
      ],
    );
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor ?? NtkColors.background,
      child: content,
    );
  }
}
