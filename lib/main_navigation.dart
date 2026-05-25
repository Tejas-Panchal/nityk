import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';
import 'package:nityk/widgets/widgets.dart';
import 'package:nityk/screens/screens.dart';

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
    NtkBottomNavDestination(label: 'Stats', icon: NtkIcons.stats),
    NtkBottomNavDestination(label: 'Tasks', icon: NtkIcons.tasks),
    NtkBottomNavDestination(label: 'Settings', icon: NtkIcons.settings),
  ];
  @override
  Widget build(BuildContext context) {
    return NtkScaffold(
      appBar: NtkAppBar(
        leading: _currentIndex == 0 ? null : const ClockWidget(),
        title: Text(widget.title, style: NtkText.headlineMedium),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NtkIcon(icon: NtkIcons.stats, size: 24),
                  SizedBox(width: 16),
                  NtkIcon(icon: NtkIcons.settings, size: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBody(),
          if (_isAddOpen)
            GestureDetector(
              onTap: () => setState(() => _isAddOpen = false),
              child: Container(),
            ),
          if (_isAddOpen)
            Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: Center(
                child: SizedBox(
                  width: 160,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(color: NtkColors.surface),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ActionItem(
                          label: 'Tasks',
                          icon: NtkIcons.tasks,
                          onTap: () {},
                        ),
                        _ActionItem(
                          label: 'Edit',
                          icon: NtkIcons.edit,
                          onTap: () {},
                        ),
                        _ActionItem(
                          label: 'Check',
                          icon: NtkIcons.check,
                          onTap: () {},
                        ),
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

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const Center(child: Text('Tasks', style: NtkText.headlineLarge));
      case 2:
        return const Center(child: Text('Stats', style: NtkText.headlineLarge));
      case 3:
        return const Center(
          child: Text('Settings', style: NtkText.headlineLarge),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _ActionItem extends StatelessWidget {
  final String label;
  final NtkIcons icon;
  final VoidCallback onTap;
  const _ActionItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(color: NtkColors.accentDim),
        width: 48,
        height: 40,
        child: Center(
          child: NtkIcon(icon: icon, size: 24, color: NtkColors.textSecondary),
        ),
      ),
    );
  }
}
