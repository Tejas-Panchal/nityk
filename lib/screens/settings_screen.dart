import 'package:flutter/widgets.dart';
import '../widgets/widgets.dart';
import '../utils/utils.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(Widget) push;
  const SettingsScreen({super.key, required this.push});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedSort = 'New->Old';
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
          children: [
            NtkSettingsTile.option(
              label: 'Sort',
              options: [
                'Grouped',
                'Old->New',
                'New->Old',
                'temp1',
                'temp2',
                'temp3',
              ],
              selected: _selectedSort,
              onChanged: (v) => setState(() => _selectedSort = v),
            ),
          ],
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
            NtkSettingsTile(
              label: 'Version',
              trailing: Text(AppConstants.version),
            ),
          ],
        ),
      ],
    );
  }
}
