import 'package:flutter/widgets.dart';
import 'package:nityk/theme/theme.dart';

class NtkTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final int maxLines;
  const NtkTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.hint = '',
    this.maxLines = 1,
  });
  @override
  State<NtkTextField> createState() => _NtkTextFieldState();
}

class _NtkTextFieldState extends State<NtkTextField> {
  bool _showHint = true;
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _showHint = widget.controller.text.isEmpty;
  }

  void _onTextChanged() {
    final show = widget.controller.text.isEmpty;
    if (show != _showHint) setState(() => _showHint = show);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: NtkColors.surfaceHigh),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Stack(
        children: [
          EditableText(
            controller: widget.controller,
            focusNode: widget.focusNode,
            style: NtkText.bodyLarge,
            cursorColor: NtkColors.accent,
            backgroundCursorColor: NtkColors.textHint,
            maxLines: widget.maxLines,
          ),
          if (_showHint && !widget.focusNode.hasFocus)
            Positioned.fill(
              child: IgnorePointer(
                child: Text(
                  widget.hint,
                  style: NtkText.bodyLarge.copyWith(color: NtkColors.textHint),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
