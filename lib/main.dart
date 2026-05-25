import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';
import 'package:nityk/main_navigation.dart';
import 'package:nityk/screens/screens.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
            (push) => HomeScreen(title: 'Nityk', push: push),
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
