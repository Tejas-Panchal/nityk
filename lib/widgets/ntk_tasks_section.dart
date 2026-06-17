import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import 'ntk_base_section.dart';

/// Collapsible section for task lists — no separators, no bottom border.
class NtkTasksSection extends StatelessWidget {
  final String title;
  final bool isOpen;
  final Color? backgroundColor;
  final List<Widget> children;

  const NtkTasksSection({
    super.key,
    required this.title,
    this.isOpen = true,
    this.backgroundColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return NtkBaseSection(
      title: title,
      isOpen: isOpen,
      backgroundColor: backgroundColor ?? NtkColors.accentContainerLight,
      showBottomBorder: false,
      showSeparators: false,
      children: children,
    );
  }
}
