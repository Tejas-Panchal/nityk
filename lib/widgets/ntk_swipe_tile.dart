import 'package:flutter/widgets.dart';
import 'ntk_icon.dart';
import '../theme/theme.dart';

class NtkSwipeTile extends StatefulWidget {
  final Widget child;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const NtkSwipeTile({
    super.key,
    required this.child,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<NtkSwipeTile> createState() => _NtkSwipeTileState();
}

class _NtkSwipeTileState extends State<NtkSwipeTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;
  double _dragOffset = 0;
  bool _isRevealed = false;
  int _revealSide = 0;
  double _animTarget = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 250),
          )
          ..addListener(() => setState(() {}))
          ..addStatusListener(_onAnimStatus);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _maxReveal => MediaQuery.of(context).size.width / 5;
  double get _executeThreshold => MediaQuery.of(context).size.width / 2;

  double get _offsetX => _controller.isAnimating ? _anim.value : _dragOffset;

  void _onAnimStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _dragOffset = _animTarget;
      if (_dragOffset == 0) {
        _isRevealed = false;
        _revealSide = 0;
      }
    }
  }

  void _startAnim(double target) {
    _animTarget = target;
    _anim = Tween<double>(
      begin: _offsetX,
      end: target,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.reset();
    _controller.forward();
  }

  void _snapBack() => _startAnim(0);

  void _onDragStart(DragStartDetails details) {
    _controller.stop();
    _dragOffset = _offsetX;
    _isRevealed = false;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _dragOffset += details.delta.dx;
    setState(() {});
  }

  void _onDragEnd(DragEndDetails details) {
    final maxR = _maxReveal;
    final exec = _executeThreshold;
    final absOffset = _offsetX.abs();

    if (absOffset > exec) {
      if (_offsetX > 0) {
        widget.onDelete?.call();
      } else {
        widget.onEdit?.call();
      }
      _startAnim(0);
    } else if (absOffset >= maxR * 0.4) {
      _revealSide = _offsetX > 0 ? 1 : -1;
      _isRevealed = true;
      _startAnim(_revealSide * maxR);
    } else {
      _startAnim(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final offset = _offsetX;
    final maxR = _maxReveal;
    final absOffset = offset.abs();
    final minShow = maxR * 0.4;

    return ClipRect(
      child: Stack(
        children: [
          if (offset > 0)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: absOffset,
              child: GestureDetector(
                onTap: _isRevealed && _revealSide > 0
                    ? () {
                        widget.onDelete?.call();
                        _snapBack();
                      }
                    : null,
                child: Container(
                  color: NtkColors.deleteButt,
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: (absOffset / minShow).clamp(0.0, 1.0),
                    child: const NtkIcon(
                      icon: NtkIcons.delete,
                      size: 24,
                      color: NtkColors.onAccent,
                    ),
                  ),
                ),
              ),
            ),
          if (offset < 0)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: absOffset,
              child: GestureDetector(
                onTap: _isRevealed && _revealSide < 0
                    ? () {
                        widget.onEdit?.call();
                        _snapBack();
                      }
                    : null,
                child: Container(
                  color: NtkColors.editButt,
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: (absOffset / minShow).clamp(0.0, 1.0),
                    child: const NtkIcon(
                      icon: NtkIcons.edit,
                      size: 24,
                      color: NtkColors.onAccent,
                    ),
                  ),
                ),
              ),
            ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: _onDragStart,
            onHorizontalDragUpdate: _onDragUpdate,
            onHorizontalDragEnd: _onDragEnd,
            onTap: _isRevealed ? _snapBack : null,
            child: Transform.translate(
              offset: Offset(offset, 0),
              child: IgnorePointer(ignoring: _isRevealed, child: widget.child),
            ),
          ),
        ],
      ),
    );
  }
}
