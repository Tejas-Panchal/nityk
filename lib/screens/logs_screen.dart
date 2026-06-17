import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../database/database_helper.dart';

class LogsScreen extends StatefulWidget {
  final void Function(Widget) push;
  const LogsScreen({super.key, required this.push});
  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  bool _showEditDialog = false;
  Log? _editingLog;
  Map<int, List<int>> _tagColors = {};

  @override
  void initState() {
    super.initState();
    LogService.instance.addListener(_onChanged);
    LogTimerService.instance.addListener(_onTimerChanged);
    _loadTagColors();
  }

  Future<void> _loadTagColors() async {
    final tags = TagService.instance.tags;
    final categories = CategoryService.instance.categories;
    final allPairs = await DatabaseHelper.instance.rawQuery('SELECT * FROM log_tags');
    final map = <int, List<int>>{};
    for (final pair in allPairs) {
      final logId = pair['log_id'] as int;
      final tagId = pair['tag_id'] as int;
      final tag = tags.firstWhere((t) => t.id == tagId,
          orElse: () => Tag(name: '', categoryId: 0));
      final cat = categories.firstWhere((c) => c.id == tag.categoryId,
          orElse: () => Category(name: '', color: 0));
      map.putIfAbsent(logId, () => []).add(cat.color);
    }
    if (mounted) setState(() => _tagColors = map);
  }

  @override
  void dispose() {
    LogService.instance.removeListener(_onChanged);
    LogTimerService.instance.removeListener(_onTimerChanged);
    super.dispose();
  }

  void _onChanged() {
    _loadTagColors();
    setState(() {});
  }
  void _onTimerChanged() {
    _loadTagColors();
    setState(() {});
  }

  static (int year, int month) _parseYearMonth(String dateStr) {
    return (
      int.parse(dateStr.substring(0, 4)),
      int.parse(dateStr.substring(4, 6)),
    );
  }

  static String _monthName(int m) {
    const names = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return names[m];
  }

  List<Map<String, dynamic>> _groupLogsByDate(List<Log> logs) {
    final map = <String, List<Log>>{};
    for (final log in logs) {
      map.putIfAbsent(log.date, () => []).add(log);
    }
    final entries = map.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    return entries.map((e) => {'date': e.key, 'logs': e.value}).toList();
  }

  Widget _buildDateSection(String date, List<Log> logs, {bool child = false}) {
    final totalSeconds = logs.fold<int>(
      0,
      (sum, l) => sum + (l.durationSeconds ?? 0),
    );
    final tiles = logs.reversed.map((log) {
      return NtkSwipeTile(
        onEdit: () {
          setState(() {
            _editingLog = log;
            _showEditDialog = true;
          });
        },
        onDelete: () async {
          LogTimerService.instance.stop(log.id!);
          await LogService.instance.delete(log.id!);
        },
        child: NtkLogTile(
          log: log,
          tagColors: log.id != null ? _tagColors[log.id!] ?? [] : [],
        ),
      );
    }).toList();

    final trailing = totalSeconds > 0
        ? Text(
            DateTimeUtils.formatDuration(Duration(seconds: totalSeconds)),
            style: NtkText.labelLarge.copyWith(
              fontSize: 12,
              color: NtkColors.textSecondary,
            ),
          )
        : null;

    if (child) {
      return NtkLogsSection(
        key: ValueKey(date),
        title: DateTimeUtils.dateDisplay(date),
        isOpen: false,
        showBottomPadding: false,
        trailing: trailing,
        children: tiles,
      );
    }

    return NtkLogsSection(
      key: ValueKey(date),
      title: DateTimeUtils.dateDisplay(date),
      trailing: trailing,
      isOpen: true,
      showBottomPadding: true,
      children: tiles,
    );
  }

  List<Widget> _buildHierarchy(List<Log> logs) {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    final currentMonthLogs = <Log>[];
    final olderThisYear = <int, List<Log>>{};
    final olderYears = <int, Map<int, List<Log>>>{};

    for (final log in logs) {
      final (year, month) = _parseYearMonth(log.date);
      if (year == currentYear && month == currentMonth) {
        currentMonthLogs.add(log);
      } else if (year == currentYear) {
        olderThisYear.putIfAbsent(month, () => []).add(log);
      } else {
        olderYears
            .putIfAbsent(year, () => <int, List<Log>>{})
            .putIfAbsent(month, () => [])
            .add(log);
      }
    }

    final widgets = <Widget>[];

    if (currentMonthLogs.isNotEmpty) {
      final dateGroups = _groupLogsByDate(currentMonthLogs);
      final top3 = dateGroups.take(3).toList();
      final rest = dateGroups.skip(3).toList();

      for (final group in top3) {
        widgets.add(
          _buildDateSection(
            group['date'] as String,
            group['logs'] as List<Log>,
          ),
        );
      }

      if (rest.isNotEmpty) {
        final children = rest
            .map(
              (group) => _buildDateSection(
                group['date'] as String,
                group['logs'] as List<Log>,
                child: true,
              ),
            )
            .toList();
        widgets.add(
          NtkLogsSection(
            key: const ValueKey('thisMonth'),
            title: _monthName(currentMonth),
            isOpen: false,
            children: children,
          ),
        );
      }
    }

    if (olderThisYear.isNotEmpty) {
      final sortedMonths = olderThisYear.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key));
      for (final entry in sortedMonths) {
        final dateGroups = _groupLogsByDate(entry.value);
        final children = dateGroups
            .map(
              (group) => _buildDateSection(
                group['date'] as String,
                group['logs'] as List<Log>,
                child: true,
              ),
            )
            .toList();
        widgets.add(
          NtkLogsSection(
            key: ValueKey('M${entry.key}'),
            title: _monthName(entry.key),
            isOpen: false,
            children: children,
          ),
        );
      }
    }

    if (olderYears.isNotEmpty) {
      final sortedYears = olderYears.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key));
      for (final yearEntry in sortedYears) {
        final months = yearEntry.value;
        final sortedMonthEntries = months.entries.toList()
          ..sort((a, b) => b.key.compareTo(a.key));
        final yearChildren = sortedMonthEntries.map((monthEntry) {
          final dateGroups = _groupLogsByDate(monthEntry.value);
          final dateChildren = dateGroups
              .map(
                (group) => _buildDateSection(
                  group['date'] as String,
                  group['logs'] as List<Log>,
                  child: true,
                ),
              )
              .toList();
          return NtkLogsSection.child(
            key: ValueKey('Y${yearEntry.key}M${monthEntry.key}'),
            title: '${_monthName(monthEntry.key)} ${yearEntry.key}',
            children: dateChildren,
          );
        }).toList();
        widgets.add(
          NtkLogsSection(
            key: ValueKey('Y${yearEntry.key}'),
            title: '${yearEntry.key}',
            isOpen: false,
            children: yearChildren,
          ),
        );
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final logs = LogService.instance.allLogs
        .where((log) => log.finishedAt != null)
        .toList();

    if (logs.isEmpty) {
      return const Center(child: Text('No logs yet', style: NtkText.bodyLarge));
    }

    final children = _buildHierarchy(logs);

    return Stack(
      children: [
        ListView.builder(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            8 + LogTimerService.instance.bottomPillPadding,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        ),
        if (_showEditDialog && _editingLog != null)
          NtkLogDialog(
            log: _editingLog,
            onClose: () {
              setState(() {
                _showEditDialog = false;
                _editingLog = null;
              });
              LogService.instance.load();
            },
          ),
      ],
    );
  }
}
