import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';

class NtkSettingsTile extends StatelessWidget {
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  const NtkSettingsTile({
    super.key,
    required this.label,
    this.trailing,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(child: Text(label, style: NtkText.headlineMedium)),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
