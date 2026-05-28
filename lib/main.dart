import 'package:flutter/widgets.dart';
import './theme/theme.dart';
import './main_navigation.dart';
import './screens/screens.dart';
import './services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService.instance.load();
  await TaskService.instance.load();
  await LogService.instance.load();
  // Restore active timers from unfinished logs
  for (final log in LogService.instance.activeLogs) {
    if (log.id != null) {
      LogTimerService.instance.start(
        log.id!,
        log.title,
        startedAt: log.startedAt,
      );
    }
  }
  runApp(const NitykApp());
}

class NitykApp extends StatelessWidget {
  const NitykApp({super.key});
  @override
  Widget build(BuildContext context) {
    return NtkTheme(
      child: WidgetsApp(
        color: NtkColors.background,
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
          return _NoTransitionRoute<T>(settings: settings, builder: builder);
        },
        home: MainNavigationScreen(
          title: 'Nityk',
          tabBuilders: [
            (push) => HomeScreen(push: push),
            (push) => HabitsScreen(push: push),
            (push) => TasksScreen(push: push),
            (push) => LogsScreen(push: push),
          ],
        ),
      ),
    );
  }
}

class _NoTransitionRoute<T> extends PageRoute<T> {
  _NoTransitionRoute({required super.settings, required this.builder});
  final WidgetBuilder builder;
  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Duration get transitionDuration => Duration.zero;
  @override
  Duration get reverseTransitionDuration => Duration.zero;
  @override
  Color get barrierColor => const Color(0x00000000);
  @override
  String get barrierLabel => '';
  @override
  bool get maintainState => true;
}
