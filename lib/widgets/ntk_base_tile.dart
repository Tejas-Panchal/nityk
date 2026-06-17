import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

class NtkBaseTile extends StatelessWidget {
  final Widget leading;
  final Widget? trailing;
  final int tagPaddingLeft;
  final List<int> tagColors;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const NtkBaseTile({
    super.key,
    required this.leading,
    this.trailing,
    this.tagPaddingLeft = 8,
    this.tagColors = const [],
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NtkColors.surface,
        border: Border(bottom: BorderSide(color: NtkColors.border, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 48,
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onTap,
                    onLongPress: onLongPress,
                    child: leading,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      height: 48,
                      alignment: Alignment.centerRight,
                      child: trailing ?? const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (tagColors.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: tagPaddingLeft.toDouble(), bottom: 4),
              child: Row(
                children: tagColors.map((c) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Color(c),
                      shape: BoxShape.circle,
                    ),
                  ),
                )).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
