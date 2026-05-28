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
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 4,
      itemBuilder: (context, index) {
        final s = SettingsService.instance;
        switch (index) {
          case 0:
            return NtkSettingsSection(
              title: 'General',
              children: [
                NtkSettingsTile.toggle(
                  label: 'Dark Mode',
                  toggleValue: s.darkMode,
                  onToggleChanged: (v) => {},
                ),
                NtkSettingsTile.toggle(
                  label: 'Use 24h',
                  toggleValue: s.use24h,
                  onToggleChanged: (v) => {},
                ),
                NtkSettingsTile.text(
                  label: 'Date Format',
                  textValue: _dateFormat,
                  onTextChanged: (v) => setState(() => _dateFormat = v),
                ),
              ],
            );
          case 1:
            return NtkSettingsSection(
              title: 'Tasks',
              children: [
                NtkSettingsTile.option(
                  label: 'Sort',
                  options: const ['Grouped', 'Old->New', 'New->Old'],
                  selected: s.sortOrder,
                  onChanged: (v) => s.sortOrder = v,
                ),
              ],
            );
          case 2:
            return NtkSettingsSection(
              title: 'Data',
              isOpen: false,
              children: [
                NtkSettingsTile.button(
                  label: 'Delete all completed',
                  onTap: () {},
                ),
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
            );
          case 3:
            return NtkSettingsSection(
              title: 'About',
              isOpen: false,
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
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
