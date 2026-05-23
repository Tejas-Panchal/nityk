import 'package:flutter/material.dart';
import 'package:Nityk/widgets/clock_widget.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key, required this.title});
  final String title;
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<NavDestination> _destinations = const [
    NavDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    NavDestination(
      label: 'Tasks',
      icon: Icons.checklist_outlined,
      selectedIcon: Icons.checklist,
    ),
    NavDestination(
      label: 'Stats',
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart,
    ),
    NavDestination(
      label: 'Profile',
      icon: Icons.person_outlined,
      selectedIcon: Icons.person,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120,
        leading: const ClockWidget(),
        title: Text(widget.title, style: TextStyle(fontSize: 24)),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Center(
        child: Text(
          _destinations[_currentIndex].label,
          style: TextStyle(fontSize: 30),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: _destinations.map((d) {
          return NavigationDestination(
            icon: Icon(d.icon),
            selectedIcon: Icon(d.selectedIcon),
            label: d.label,
          );
        }).toList(),
      ),
    );
  }
}

class NavDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const NavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}
