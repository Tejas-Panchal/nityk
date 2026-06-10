import 'package:flutter/widgets.dart';
import 'ntk_icon.dart';
import '../theme/theme.dart';

class NtkSection extends StatefulWidget {
  final String title;
  final bool isOpen;
  final Color? backgroundColor;
  final Color openColor;
  final List<Widget> children;
  final bool showBottomBorder;
  final bool showSeparators;
  final bool showBottomPadding;

  const NtkSection({
    super.key,
    required this.title,
    this.isOpen = true,
    this.backgroundColor = NtkColors.accentContainerLight,
    this.openColor = NtkColors.surfaceHigh,
    required this.children,
    this.showBottomBorder = false,
    this.showSeparators = false,
    this.showBottomPadding = true,
  });
  @override
  State<NtkSection> createState() => _NtkSectionState();
}

class _NtkSectionState extends State<NtkSection> {
  bool _isOpen = true;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.isOpen;
  }

  @override
  void didUpdateWidget(covariant NtkSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      _isOpen = widget.isOpen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> separated;
    if (widget.showSeparators) {
      separated = [];
      for (int i = 0; i < widget.children.length; i++) {
        separated.add(widget.children[i]);
        if (i < widget.children.length - 1) {
          separated.add(Container(height: 1, color: NtkColors.border));
        }
      }
    } else {
      separated = widget.children;
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
              color: _isOpen ? widget.openColor : widget.backgroundColor,
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
              border: widget.showBottomBorder
                  ? Border(
                      bottom: BorderSide(color: NtkColors.border, width: 1),
                    )
                  : null,
            ),
            child: Column(children: separated),
          ),
        if (widget.showBottomPadding) const SizedBox(height: 8),
      ],
    );
  }
}
