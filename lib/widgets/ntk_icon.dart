import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';

// Enum of icon names matching PNG filenames
enum NtkIcons {
  home,
  tasks,
  stats,
  profile,
  add,
  back,
  settings,
  check,
  close,
  edit,
  delete;

  String get path => 'assets/icons/icon_$name.png';
}

// Widget
class NtkIcon extends StatelessWidget {
  final NtkIcons icon;
  final double size;
  final Color color;
  const NtkIcon({
    super.key,
    required this.icon,
    this.size = 32,
    this.color = NtkColors.textPrimary,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        child: Image.asset(icon.path, width: size, height: size),
      ),
    );
  }
}
