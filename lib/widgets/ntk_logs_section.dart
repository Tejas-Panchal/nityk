import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import 'ntk_section.dart';

/// Collapsible section for log lists — no separators, no bottom border.
class NtkLogsSection extends StatelessWidget {
  final String title;
  final bool isOpen;
  final Color openColor;
  final bool showBottomPadding;
  final Widget? trailing;
  final List<Widget> children;

  const NtkLogsSection({
    super.key,
    required this.title,
    this.isOpen = true,
    this.openColor = NtkColors.surfaceHigh,
    this.showBottomPadding = true,
    this.trailing,
    required this.children,
  });

  const NtkLogsSection.child({
    super.key,
    required this.title,
    this.isOpen = false,
    this.openColor = NtkColors.textDisabled,
    this.showBottomPadding = false,
    this.trailing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return NtkSection(
      title: title,
      isOpen: isOpen,
      openColor: openColor,
      showBottomPadding: showBottomPadding,
      trailing: trailing,
      showBottomBorder: false,
      showSeparators: false,
      children: children,
    );
  }
}
