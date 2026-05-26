import 'package:flutter/widgets.dart';
import 'package:nityk/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(Widget) push;
  const SettingsScreen({super.key, required this.push});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        NtkSettingsSection(
          title: 'General',
          children: [
            NtkSettingsTile(label: 'Dark Mode', trailing: Text('On')),
            NtkSettingsTile(label: 'Date Format', trailing: Text('DD-MM-YYYY')),
          ],
        ),
        NtkSettingsSection(
          title: 'Tasks',
          children: [NtkSettingsTile(label: 'Sort')],
        ),
        NtkSettingsSection(
          title: 'Data',
          children: [
            NtkSettingsTile(label: 'Delete all completed'),
            NtkSettingsTile(label: 'Reset all data'),
          ],
        ),
        NtkSettingsSection(
          title: 'About',
          children: [
            NtkSettingsTile(label: 'Version', trailing: Text('1.0.0')),
          ],
        ),
      ],
    );
  }
}
