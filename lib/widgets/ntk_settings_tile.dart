import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import 'ntk_icon.dart';

class NtkSettingsTile extends StatefulWidget {
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final List<String>? options;
  final String? selected;
  final ValueChanged<String>? onChanged;
  final bool? toggleValue;
  final ValueChanged<bool>? onToggleChanged;
  final String? textValue;
  final ValueChanged<String>? onTextChanged;
  final String? hint;
  final bool? isRisky;
  final String? secondaryLabel;
  final String? description;

  const NtkSettingsTile({
    super.key,
    required this.label,
    this.trailing,
    this.onTap,
  }) : options = null,
       selected = null,
       onChanged = null,
       toggleValue = null,
       onToggleChanged = null,
       textValue = null,
       onTextChanged = null,
       hint = null,
       isRisky = null,
       secondaryLabel = null,
       description = null;

  const NtkSettingsTile.option({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
  }) : trailing = null,
       onTap = null,
       toggleValue = null,
       onToggleChanged = null,
       textValue = null,
       onTextChanged = null,
       hint = null,
       isRisky = null,
       secondaryLabel = null,
       description = null;

  const NtkSettingsTile.toggle({
    super.key,
    required this.label,
    required this.toggleValue,
    required this.onToggleChanged,
  }) : trailing = null,
       onTap = null,
       options = null,
       selected = null,
       onChanged = null,
       textValue = null,
       onTextChanged = null,
       hint = null,
       isRisky = null,
       secondaryLabel = null,
       description = null;

  const NtkSettingsTile.text({
    super.key,
    required this.label,
    required this.textValue,
    required this.onTextChanged,
    this.hint = '',
  }) : trailing = null,
       onTap = null,
       options = null,
       selected = null,
       onChanged = null,
       toggleValue = null,
       onToggleChanged = null,
       isRisky = null,
       secondaryLabel = null,
       description = null;

  const NtkSettingsTile.button({
    super.key,
    required this.label,
    required this.onTap,
    this.isRisky = false,
    this.secondaryLabel = '',
  }) : trailing = null,
       options = null,
       selected = null,
       onChanged = null,
       toggleValue = null,
       onToggleChanged = null,
       textValue = null,
       onTextChanged = null,
       hint = null,
       description = null;

  const NtkSettingsTile.banner({
    super.key,
    required this.label,
    required this.secondaryLabel,
    this.description,
  }) : trailing = null,
       onTap = null,
       options = null,
       selected = null,
       onChanged = null,
       toggleValue = null,
       onToggleChanged = null,
       textValue = null,
       onTextChanged = null,
       hint = null,
       isRisky = null;

  @override
  State<NtkSettingsTile> createState() => _NtkSettingsTileState();
}

class _NtkSettingsTileState extends State<NtkSettingsTile> {
  bool _isOpen = false;
  bool _isEditing = false;
  bool _showConfirm = false;
  late TextEditingController _textController;
  late FocusNode _textFocusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textFocusNode = FocusNode();
    _textFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.removeListener(_onFocusChange);
    _textFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_textFocusNode.hasFocus && _isEditing) _commitText();
  }

  void _commitText() {
    widget.onTextChanged?.call(_textController.text);
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options != null) return _buildOption();
    if (widget.toggleValue != null) return _buildToggle();
    if (widget.textValue != null) return _buildText();
    if (widget.isRisky != null) return _buildButton();
    if (widget.secondaryLabel != null) return _buildBanner();
    return _buildDefault();
  }

  Widget _buildBanner() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isOpen = !_isOpen),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(widget.label, style: NtkText.headlineMedium),
                ),
                Text(widget.secondaryLabel!, style: NtkText.bodyMedium),
              ],
            ),
          ),
        ),
        if (_isOpen && widget.description != null)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 500),
            child: Container(
              color: NtkColors.surfaceHigh,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SingleChildScrollView(
                child: Text(widget.description!, style: NtkText.bodyMedium),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDefault() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(child: Text(widget.label, style: NtkText.headlineMedium)),
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
      ),
    );
  }

  Widget _buildOption() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isOpen = !_isOpen),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(widget.label, style: NtkText.headlineMedium),
                ),
                Text(widget.selected!, style: NtkText.bodyMedium),
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: _isOpen ? 0.25 : 0.75,
                  duration: const Duration(milliseconds: 200),
                  child: const NtkIcon(
                    icon: NtkIcons.arrow,
                    size: 16,
                    color: NtkColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isOpen)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 4 * 40.0),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: widget.options!.map((opt) {
                final isSelected = opt == widget.selected;
                return GestureDetector(
                  onTap: () {
                    widget.onChanged!(opt);
                    setState(() => _isOpen = false);
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? NtkColors.surfaceHigh : null,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 24),
                        Expanded(
                          child: Text(
                            opt,
                            textAlign: TextAlign.right,
                            style: NtkText.bodyMedium,
                          ),
                        ),
                        if (isSelected)
                          Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: const NtkIcon(
                              icon: NtkIcons.check,
                              size: 16,
                              color: NtkColors.textSecondary,
                            ),
                          ),
                        if (!isSelected) SizedBox(width: 20),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildToggle() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: Text(widget.label, style: NtkText.headlineMedium)),
          _ToggleWidget(
            value: widget.toggleValue!,
            onChanged: widget.onToggleChanged!,
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (widget.isRisky!) {
              setState(() => _showConfirm = !_showConfirm);
            } else {
              widget.onTap?.call();
            }
          },
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(widget.label, style: NtkText.headlineMedium),
                ),
                if (widget.secondaryLabel!.isNotEmpty)
                  Text(widget.secondaryLabel!, style: NtkText.bodyMedium),
              ],
            ),
          ),
        ),
        if (_showConfirm)
          GestureDetector(
            onTap: () => setState(() => _showConfirm = false),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: NtkColors.surfaceHigh),
              child: Row(
                children: [
                  Text('Are you sure?', style: NtkText.bodyMedium),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _showConfirm = false),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('No', style: NtkText.bodyLarge),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onTap?.call();
                      setState(() => _showConfirm = false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Yes',
                        style: NtkText.bodyLarge.copyWith(
                          color: NtkColors.error,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildText() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (_isEditing) {
              _commitText();
            } else {
              _textController.text = widget.textValue!;
              setState(() => _isEditing = true);
              _textFocusNode.requestFocus();
            }
          },
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(widget.label, style: NtkText.headlineMedium),
                ),
                Text(
                  widget.textValue!.isEmpty ? widget.hint! : widget.textValue!,
                  style: NtkText.bodyMedium.copyWith(
                    color: widget.textValue!.isEmpty
                        ? NtkColors.textHint
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isEditing)
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: NtkColors.surfaceHigh),
            child: Align(
              child: EditableText(
                controller: _textController,
                focusNode: _textFocusNode,
                style: NtkText.bodyMedium,
                cursorColor: NtkColors.accent,
                backgroundCursorColor: NtkColors.textHint,
                onSubmitted: (_) => _commitText(),
              ),
            ),
          ),
      ],
    );
  }
}

class _ToggleWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleWidget({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 24,
        decoration: BoxDecoration(
          color: value ? NtkColors.accent : NtkColors.surfaceHigh,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(4),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: value ? NtkColors.onAccent : NtkColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
