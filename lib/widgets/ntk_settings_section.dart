import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import 'ntk_section.dart';

/// Collapsible section for settings — has 1px separators between children
/// and a bottom border on the children container.
class NtkSettingsSection extends StatelessWidget {
  final String title;
  final bool isOpen;
  final Color? backgroundColor;
  final List<Widget> children;

  const NtkSettingsSection({
    super.key,
    required this.title,
    this.isOpen = true,
    this.backgroundColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return NtkSection(
      title: title,
      isOpen: isOpen,
      backgroundColor: backgroundColor ?? NtkColors.accentContainerLight,
      showBottomBorder: true,
      showSeparators: true,
      children: children,
    );
  }
}
