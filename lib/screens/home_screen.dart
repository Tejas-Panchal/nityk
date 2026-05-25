import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';
import 'package:nityk/utils/datetime_utils.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  final void Function(Widget) push;
  const HomeScreen({super.key, required this.title, required this.push});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  String _date = '';
  @override
  void initState() {
    super.initState();
    _update();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _update();
    });
    _scrollController.addListener(() => setState(() {}));
  }

  void _update() {
    setState(() {
      _date = DateTimeUtils.dateFull();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.25;
    const minHeight = 112.0;
    final offset = _scrollController.hasClients ? _scrollController.offset : 0;
    final clockHeight = (maxHeight - offset).clamp(minHeight, maxHeight);
    final progress = (clockHeight - minHeight) / (maxHeight - minHeight);
    final showFull = progress > 0.3;
    final fontSize = 56.0 + (72.0 - 56.0) * progress;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: NtkColors.accentDim),
          height: clockHeight,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showFull)
                  Text(widget.title, style: NtkText.titleExtraLarge),
                Text(DateTimeUtils.time(), style: NtkText.style(fontSize)),
                if (showFull)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(_date, style: NtkText.titleLarge),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              SizedBox(
                height: maxHeight * 2,
                child: Center(
                  child: Text('Home', style: NtkText.headlineLarge),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
