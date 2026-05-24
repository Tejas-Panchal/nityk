import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';
import 'package:nityk/widgets/widgets.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key, required this.title});
  final String title;
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  bool _isAddOpen = false;
  final List<NtkBottomNavDestination> _destinations = const [
    NtkBottomNavDestination(label: 'Home', icon: NtkIcons.home),
    NtkBottomNavDestination(label: 'Tasks', icon: NtkIcons.tasks),
    NtkBottomNavDestination(label: 'Stats', icon: NtkIcons.stats),
    NtkBottomNavDestination(label: 'Settings', icon: NtkIcons.settings),
  ];
  @override
  Widget build(BuildContext context) {
    return NtkScaffold(
      appBar: NtkAppBar(
        leading: const ClockWidget(),
        title: Text(widget.title, style: NtkText.headlineMedium),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: NtkIcon(icon: NtkIcons.profile, size: 24),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              _destinations[_currentIndex].label,
              style: NtkText.headlineLarge,
            ),
          ),
          if (_isAddOpen)
            Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: Center(
                child: SizedBox(
                  width: 210,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(color: NtkColors.surface),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ActionItem(icon: NtkIcons.add),
                        _ActionItem(icon: NtkIcons.add),
                        _ActionItem(icon: NtkIcons.add),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNav: NtkBottomNav(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: _destinations,
        isAddOpen: _isAddOpen,
        onAddPressed: () {
          setState(() => _isAddOpen = !_isAddOpen);
        },
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final NtkIcons icon;
  const _ActionItem({required this.icon});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 48,
        height: 48,
        child: Center(
          child: NtkIcon(icon: icon, size: 24, color: NtkColors.textSecondary),
        ),
      ),
    );
  }
}
