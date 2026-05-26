import 'package:flutter/widgets.dart';
import '../widgets/widgets.dart';
import '../utils/utils.dart';
import '../services/services.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(Widget) push;
  const SettingsScreen({super.key, required this.push});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _dateFormat = 'DD-MM-YYYY';

  @override
  void initState() {
    super.initState();
    SettingsService.instance.addListener(_onChanged);
  }

  @override
  void dispose() {
    SettingsService.instance.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});
  @override
  Widget build(BuildContext context) {
    final s = SettingsService.instance;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        NtkSection(
          title: 'General',
          children: [
            NtkSettingsTile.toggle(
              label: 'Dark Mode',
              toggleValue: s.darkMode,
              onToggleChanged: (v) => s.darkMode = v,
            ),
            NtkSettingsTile.toggle(
              label: 'Use 24h',
              toggleValue: s.use24h,
              onToggleChanged: (v) => s.use24h = v,
            ),
            NtkSettingsTile.text(
              label: 'Date Format',
              textValue: _dateFormat,
              onTextChanged: (v) => setState(() => _dateFormat = v),
            ),
          ],
        ),
        NtkSection(
          title: 'Tasks',
          children: [
            NtkSettingsTile.option(
              label: 'Sort',
              options: const ['Grouped', 'Old->New', 'New->Old'],
              selected: s.sortOrder,
              onChanged: (v) => s.sortOrder = v,
            ),
          ],
        ),
        NtkSection(
          title: 'Data',
          children: [
            NtkSettingsTile.button(label: 'Delete all completed', onTap: () {}),
            NtkSettingsTile.button(
              label: 'Reset Settings',
              onTap: () {},
              isRisky: true,
            ),
            NtkSettingsTile.button(
              label: 'Reset Tasks',
              onTap: () {},
              isRisky: true,
            ),
            NtkSettingsTile.button(
              label: 'Reset all Data',
              onTap: () {},
              isRisky: true,
            ),
          ],
        ),
        NtkSection(
          title: 'About',
          children: [
            NtkSettingsTile.banner(
              label: 'App Name',
              secondaryLabel: 'Nityk',
              description:
                  'A customizable habit tracker and todo app.\n\nBuilt with Flutter.',
            ),
            NtkSettingsTile.banner(
              label: 'Version',
              secondaryLabel: AppConstants.version,
            ),
          ],
        ),
      ],
    );
  }
}
