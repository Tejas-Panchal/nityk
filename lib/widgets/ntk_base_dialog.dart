import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

class NtkBaseDialog extends StatelessWidget {
  final VoidCallback onClose;
  final String title;
  final Widget child;
  final VoidCallback? onSave;
  final String saveLabel;
  final Color? saveColor;
  final VoidCallback? onDelete;
  final bool canSave;

  const NtkBaseDialog({
    super.key,
    required this.onClose,
    required this.title,
    required this.child,
    this.onSave,
    this.saveLabel = 'Save',
    this.saveColor,
    this.onDelete,
    this.canSave = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(color: NtkColors.scrim),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 60),
            curve: Curves.linear,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: NtkColors.surface,
                  border: NtkColors.standardBorder,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: NtkText.titleLarge),
                    const SizedBox(height: 16),
                    child,
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: onClose,
                            child: Container(
                              height: 44,
                              alignment: Alignment.center,
                              child: Text(
                                'Cancel',
                                style: NtkText.labelLarge.copyWith(
                                  color: NtkColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (onDelete != null) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: onDelete,
                              child: Container(
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: NtkColors.deleteButt,
                                ),
                                child: Text(
                                  'Delete',
                                  style: NtkText.labelLarge.copyWith(
                                    color: NtkColors.onAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (onSave != null) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: canSave ? onSave : null,
                              child: Container(
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                      saveColor ??
                                      (canSave
                                          ? NtkColors.accentContainerLight
                                          : NtkColors.textDisabled),
                                ),
                                child: Text(
                                  saveLabel,
                                  style: NtkText.labelLarge.copyWith(
                                    color: NtkColors.onAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
