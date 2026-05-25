import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';
import 'package:nityk/widgets/widgets.dart';
import 'package:nityk/screens/screens.dart';

typedef ScreenBuilder = Widget Function(void Function(Widget) push);

class MainNavigationScreen extends StatefulWidget {
  final String title;
  final List<ScreenBuilder> tabBuilders;
  final List<NtkBottomNavDestination> destinations;
  const MainNavigationScreen({
    super.key,
    required this.title,
    required this.tabBuilders,
    this.destinations = const [
      NtkBottomNavDestination(label: 'Home', icon: NtkIcons.home),
      NtkBottomNavDestination(label: 'Habits', icon: NtkIcons.add),
      NtkBottomNavDestination(label: 'Tasks', icon: NtkIcons.tasks),
      NtkBottomNavDestination(label: 'Logs', icon: NtkIcons.add),
    ],
  });
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  bool _isAddOpen = false;
  bool _showStats = false;
  String? _pushedTitle;
  final List<Widget> _screenStack = [];

  void pushScreen(Widget screen, {String title = ''}) {
    setState(() {
      _screenStack.add(screen);
      _pushedTitle = title.isEmpty ? null : title;
    });
  }

  void goHome() {
    setState(() {
      _screenStack.clear();
      _pushedTitle = null;
      _showStats = false;
      _currentIndex = 0;
    });
  }

  void popSettings() {
    if (_screenStack.isNotEmpty) {
      setState(() {
        _screenStack.removeLast();
        _pushedTitle = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPushed = _screenStack.isNotEmpty;
    final actions = <Widget>[];
    if (!(hasPushed && _pushedTitle == 'Settings')) {
      if (!_showStats) {
        actions.add(
          GestureDetector(
            onTap: () => setState(() => _showStats = true),
            child: const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16, right: 8, left: 16),
              child: NtkIcon(icon: NtkIcons.stats, size: 24),
            ),
          ),
        );
      }
      actions.add(
        GestureDetector(
          onTap: () =>
              pushScreen(SettingsScreen(push: pushScreen), title: 'Settings'),
          child: const Padding(
            padding: EdgeInsets.only(top: 16, bottom: 16, right: 16, left: 8),
            child: NtkIcon(icon: NtkIcons.settings, size: 24),
          ),
        ),
      );
    }

    return PopScope(
      canPop: !hasPushed && !_showStats && _currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (hasPushed && _pushedTitle == 'Settings') {
          popSettings();
        } else {
          goHome();
        }
      },
      child: NtkScaffold(
        appBar: NtkAppBar(
          leading: hasPushed
              ? GestureDetector(
                  onTap: () {
                    if (_pushedTitle == 'Settings') {
                      popSettings();
                    } else {
                      goHome();
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: NtkIcon(icon: NtkIcons.back, size: 24),
                  ),
                )
              : (!_showStats && _currentIndex == 0
                    ? null
                    : const ClockWidget()),
          title: Text(
            hasPushed
                ? (_pushedTitle ?? '')
                : _showStats
                ? 'Stats'
                : widget.destinations[_currentIndex].label,
            style: NtkText.headlineMedium,
          ),
          actions: actions,
        ),
        body: Stack(
          children: [
            if (hasPushed)
              _screenStack.last
            else if (_showStats)
              StatsScreen(push: pushScreen)
            else
              widget.tabBuilders[_currentIndex](pushScreen),
            if (_isAddOpen && _pushedTitle != 'Settings')
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ActionItem(
                            label: 'Tasks',
                            icon: NtkIcons.tasks,
                            onTap: null,
                          ),
                          _ActionItem(
                            label: 'Edit',
                            icon: NtkIcons.edit,
                            onTap: null,
                          ),
                          _ActionItem(
                            label: 'Check',
                            icon: NtkIcons.check,
                            onTap: null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        bottomNav: hasPushed && _pushedTitle == 'Settings'
            ? null
            : NtkBottomNav(
                selectedIndex: _showStats ? -1 : _currentIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _currentIndex = index;
                    _showStats = false;
                  });
                },
                destinations: widget.destinations,
                isAddOpen: _isAddOpen,
                onAddPressed: () {
                  setState(() => _isAddOpen = !_isAddOpen);
                },
              ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final String label;
  final NtkIcons icon;
  final VoidCallback? onTap;
  const _ActionItem({required this.label, required this.icon, this.onTap});
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
