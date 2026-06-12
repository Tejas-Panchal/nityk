import 'package:flutter/widgets.dart';

class NtkTagChip extends StatelessWidget {
  final int color;
  final double size;

  const NtkTagChip({super.key, required this.color, this.size = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: Color(color), shape: BoxShape.circle),
    );
  }
}
