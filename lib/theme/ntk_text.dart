import 'package:flutter/widgets.dart';
import 'ntk_colors.dart';

class NtkText {
  const NtkText();

  static const String _font = 'Jersey25';
  // Large headers
  static const displayLarge = TextStyle(
    fontFamily: _font,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    color: NtkColors.textPrimary,
    height: 1.12,
  );
  static const displayMedium = TextStyle(
    fontFamily: _font,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    color: NtkColors.textPrimary,
    height: 1.15,
  );
  // Section titles
  static const headlineLarge = TextStyle(
    fontFamily: _font,
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: NtkColors.textPrimary,
    height: 1.25,
  );
  static const headlineMedium = TextStyle(
    fontFamily: _font,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: NtkColors.textPrimary,
    height: 1.29,
  );
  // Card / list titles
  static const titleLarge = TextStyle(
    fontFamily: _font,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: NtkColors.textPrimary,
    height: 1.27,
  );
  static const titleMedium = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: NtkColors.textPrimary,
    height: 1.50,
  );
  static const titleSmall = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: NtkColors.textPrimary,
    height: 1.43,
  );
  // Body text
  static const bodyLarge = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: NtkColors.textPrimary,
    height: 1.50,
  );
  static const bodyMedium = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: NtkColors.textSecondary,
    height: 1.43,
  );
  static const bodySmall = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: NtkColors.textHint,
    height: 1.33,
  );
  // Labels / buttons
  static const labelLarge = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: NtkColors.onAccent,
    height: 1.43,
  );
  static const labelMedium = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: NtkColors.textSecondary,
    height: 1.33,
  );
  static const labelSmall = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: NtkColors.textHint,
    height: 1.45,
  );
}
