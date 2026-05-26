import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import 'ntk_icon.dart';

class NtkSettingsTile extends StatefulWidget {
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final List<String>? options;
  final String? selected;
  final ValueChanged<String>? onChanged;

  const NtkSettingsTile({
    super.key,
    required this.label,
    this.trailing,
    this.onTap,
  }) : options = null,
       selected = null,
       onChanged = null;

  const NtkSettingsTile.option({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
  }) : trailing = null,
       onTap = null;

  @override
  State<NtkSettingsTile> createState() => _NtkSettingsTileState();
}

class _NtkSettingsTileState extends State<NtkSettingsTile> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    if (widget.options != null) return _buildOption();
    return _buildDefault();
  }

  Widget _buildDefault() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(child: Text(widget.label, style: NtkText.headlineMedium)),
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
      ),
    );
  }

  Widget _buildOption() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isOpen = !_isOpen),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(widget.label, style: NtkText.headlineMedium),
                ),
                Text(widget.selected!, style: NtkText.bodyMedium),
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: _isOpen ? 0.25 : 0.75,
                  duration: const Duration(milliseconds: 200),
                  child: const NtkIcon(
                    icon: NtkIcons.arrow,
                    size: 16,
                    color: NtkColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isOpen)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 4 * 40.0),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: widget.options!.map((opt) {
                final isSelected = opt == widget.selected;
                return GestureDetector(
                  onTap: () {
                    widget.onChanged!(opt);
                    setState(() => _isOpen = false);
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? NtkColors.surfaceHigh : null,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 24),
                        Expanded(
                          child: Text(
                            opt,
                            textAlign: TextAlign.right,
                            style: NtkText.bodyMedium,
                          ),
                        ),
                        if (isSelected)
                          Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: const NtkIcon(
                              icon: NtkIcons.check,
                              size: 16,
                              color: NtkColors.textSecondary,
                            ),
                          ),
                        if (!isSelected) SizedBox(width: 20),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
