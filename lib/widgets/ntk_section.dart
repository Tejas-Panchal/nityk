import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class NtkSection extends StatefulWidget {
  final String title;
  final List<Widget> children;
  const NtkSection({super.key, required this.title, required this.children});
  @override
  State<NtkSection> createState() => _NtkSectionState();
}

class _NtkSectionState extends State<NtkSection> {
  bool _isOpen = true;
  @override
  Widget build(BuildContext context) {
    // separate children with dividers (same as now)
    final separated = <Widget>[];
    for (int i = 0; i < widget.children.length; i++) {
      separated.add(widget.children[i]);
      if (i < widget.children.length - 1) {
        separated.add(Container(height: 1, color: NtkColors.border));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isOpen = !_isOpen),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _isOpen
                  ? NtkColors.surfaceHigh
                  : NtkColors.accentContainerLight,
            ),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: _isOpen ? 0.75 : 0.5, // 0.5 = >, 0.75 = v
                  duration: const Duration(milliseconds: 200),
                  child: NtkIcon(
                    icon: NtkIcons.arrow,
                    size: 16,
                    color: NtkColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: NtkText.labelLarge.copyWith(
                    color: NtkColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isOpen)
          Container(
            decoration: BoxDecoration(
              color: NtkColors.surface,
              border: Border(
                bottom: BorderSide(color: NtkColors.border, width: 1),
              ),
            ),
            child: Column(children: separated),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
