import 'dart:async';
import 'package:flutter/widgets.dart';
import './theme/theme.dart';
import './widgets/widgets.dart';
import './screens/screens.dart';
import './services/services.dart';

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
      NtkBottomNavDestination(label: 'Habits', icon: NtkIcons.habit),
      NtkBottomNavDestination(label: 'Tasks', icon: NtkIcons.tasks),
      NtkBottomNavDestination(label: 'Logs', icon: NtkIcons.log),
    ],
  });
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late final List<Widget> _tabPages;
  int _currentIndex = 0;
  bool _isAddOpen = false;
  Timer? _addTimer;
  bool _showStats = false;
  bool _showAddTask = false;
  bool _showAddLog = false;
  String? _pushedTitle;
  final List<Widget> _screenStack = [];

  @override
  void initState() {
    super.initState();
    _tabPages = widget.tabBuilders.map((b) => b(pushScreen)).toList();
    LogTimerService.instance.addListener(_onTimerChanged);
  }

  void _onTimerChanged() => setState(() {});

  void pushScreen(Widget screen, {String title = ''}) {
    setState(() {
      _screenStack.add(screen);
      _pushedTitle = title.isEmpty ? null : title;
    });
  }

  void goHome() {
    _addTimer?.cancel();
    setState(() {
      _screenStack.clear();
      _pushedTitle = null;
      _showStats = false;
      _showAddTask = false;
      _showAddLog = false;
      _currentIndex = 0;
    });
  }

  void popSettings() {
    if (_screenStack.isNotEmpty) {
      _addTimer?.cancel();
      setState(() {
        _screenStack.removeLast();
        _pushedTitle = null;
      });
    }
  }

  void _toggleAddBar() {
    if (_isAddOpen) {
      _addTimer?.cancel();
      setState(() => _isAddOpen = false);
    } else {
      _addTimer?.cancel();
      setState(() => _isAddOpen = true);
      _addTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) setState(() => _isAddOpen = false);
      });
    }
  }

  @override
  void dispose() {
    _addTimer?.cancel();
    LogTimerService.instance.removeListener(_onTimerChanged);
    super.dispose();
  }

  List<Widget> _buildTimerPills(bool hasPushed) {
    final timers = LogTimerService.instance.timers;
    const pillHeight = 36.0;
    const pillGap = 8.0;
    const bottomOffset = 64.0; // above bottom nav (~56px + padding)
    final pills = <Widget>[];
    for (int i = 0; i < timers.length; i++) {
      final t = timers[i];
      pills.add(
        Positioned(
          right: 16,
          bottom: bottomOffset + (i * (pillHeight + pillGap)),
          child: NtkLogTimerPill(
            title: t.title,
            startedAt: t.startedAt,
            onStop: () {
              LogTimerService.instance.stop(t.logId);
              LogService.instance.stopTimer(t.logId);
            },
          ),
        ),
      );
    }
    return pills;
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
              IndexedStack(index: _currentIndex, children: _tabPages),
            if (_isAddOpen && _pushedTitle != 'Settings')
              GestureDetector(
                onTap: () {
                  _addTimer?.cancel();
                  setState(() => _isAddOpen = false);
                },
                child: Container(),
              ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ActionItem(
                            label: 'Add Habit',
                            icon: NtkIcons.habit,
                            onTap: null,
                          ),
                          _ActionItem(
                            label: 'Tasks',
                            icon: NtkIcons.tasks,
                            onTap: () {
                              _addTimer?.cancel();
                              setState(() {
                                _isAddOpen = false;
                                _showAddTask = true;
                              });
                            },
                          ),
                          _ActionItem(
                            label: 'Add Log',
                            icon: NtkIcons.log,
                            onTap: () {
                              _addTimer?.cancel();
                              setState(() {
                                _isAddOpen = false;
                                _showAddLog = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (_showAddTask)
              NtkTaskDialog(
                onClose: () {
                  TaskService.instance.load();
                  setState(() => _showAddTask = false);
                },
              ),
            if (_showAddLog)
              NtkLogDialog(
                isTimer: true,
                onClose: () => setState(() => _showAddLog = false),
              ),
            // Timer pills
            if (LogTimerService.instance.timers.isNotEmpty &&
                !(hasPushed && _pushedTitle == 'Settings') &&
                !_showAddTask &&
                !_showAddLog)
              ..._buildTimerPills(hasPushed),
          ],
        ),
        bottomNav: hasPushed && _pushedTitle == 'Settings'
            ? null
            : NtkBottomNav(
                selectedIndex: _showStats ? -1 : _currentIndex,
                onDestinationSelected: (index) {
                  _addTimer?.cancel();
                  setState(() {
                    _currentIndex = index;
                    _showStats = false;
                    _isAddOpen = false;
                    _showAddTask = false;
                    _showAddLog = false;
                  });
                },
                destinations: widget.destinations,
                isAddOpen: _isAddOpen,
                onAddPressed: _toggleAddBar,
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
