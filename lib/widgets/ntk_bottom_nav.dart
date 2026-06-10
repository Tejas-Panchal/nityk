import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import 'widgets.dart';

class NtkBottomNavDestination {
  final String label;
  final NtkIcons icon;

  const NtkBottomNavDestination({
    required this.label,
    required this.icon,
  });
}

class NtkBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NtkBottomNavDestination> destinations;
  final VoidCallback onAddPressed;
  final bool isAddOpen;

  const NtkBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.onAddPressed,
    required this.isAddOpen,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < destinations.length ~/ 2; i++)
            _NavItem(
              destination: destinations[i],
              isSelected: i == selectedIndex,
              onTap: () => onDestinationSelected(i),
            ),
          _AddButton(onTap: onAddPressed, isOpen: isAddOpen),
          for (int i = destinations.length ~/ 2; i < destinations.length; i++)
            _NavItem(
              destination: destinations[i],
              isSelected: i == selectedIndex,
              onTap: () => onDestinationSelected(i),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final NtkBottomNavDestination destination;
  final bool isSelected;
  final VoidCallback onTap;
  const _NavItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 72,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? NtkColors.accentContainer : null,
        ),
        child: Center(
          child: NtkIcon(
            icon: destination.icon,
            size: 24,
            color: isSelected ? NtkColors.onAccent : NtkColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isOpen;
  const _AddButton({required this.onTap, required this.isOpen});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: isOpen ? 0.785 : 0), // 0° → 45°
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        builder: (context, angle, child) {
          return Transform.rotate(
            angle: angle,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color.lerp(
                  NtkColors.accentContainer,
                  NtkColors.accent,
                  (angle / 0.785).clamp(0.0, 1.0),
                ),
              ),
              child: const Center(
                child: NtkIcon(
                  icon: NtkIcons.add,
                  size: 24,
                  color: NtkColors.onAccent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
