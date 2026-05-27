import 'package:flutter/widgets.dart';

class NtkColors {
  const NtkColors();

  // Seed
  static const seed = Color(0xFF4F006E);
  // Brand
  static const brand = Color(0xFF4F006E);
  static const brandLight = Color(0xFFD0A9FF);
  static const brandDark = Color(0xFF2A003A);
  // Backgrounds & surfaces
  static const background = Color(0xFF1C1B1F);
  static const surface = Color(0xFF2B2930);
  static const surfaceHigh = Color(0xFF3A3840);
  static const surfaceContainer = Color(0xFF242228);
  // Text
  static const textPrimary = Color(0xFFE6E1E5);
  static const textSecondary = Color(0xFFCAC4D0);
  static const textHint = Color(0xFF938F99);
  static const textDisabled = Color(0xFF6E6A73);
  // Interactive
  static const accentDim = Color(0xFF691B88); // Muted accent
  static const accent = Color(0xFFD0A9FF); // Main accent (current)
  static const accentBright = Color(0xFFE8CCFF); // Bright highlight
  static const accentContainer = Color(0xFF4F006E); // Container (current)
  static const accentContainerDim = Color(0xFF3A0050); // Darker container
  static const accentContainerLight = Color(0xFF6A1B8A); // Lighter container
  static const onAccent = Color(0xFFFFFFFF); // Text on accent (current)
  static const onAccentContainer = Color(0xFFE6D0F0); // Text on container
  // Status
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFFFB4AB);
  static const streak = Color(0xFFFF9800);
  static const overdue = Color(0xFFFFB4AB);
  // Priority
  static const priorityHigh = Color(0xFFFFB4AB);
  static const priorityMedium = Color(0xFFFFC107);
  static const priorityLow = Color(0xFFA8DAB5);
  static const priorityHighDark = Color(0xFF5C2525);
  static const priorityMediumDark = Color(0xFF5C4A0A);
  static const priorityLowDark = Color(0xFF1A4A28);
  // Borders & dividers
  static const border = Color(0xFFE8CCFF);
  static const divider = Color(0xFFE8CCFF);
  static Border get standardBorder =>
      Border.all(color: NtkColors.border, width: 1);
  // Overlay
  static const scrim = Color(0x99000000);
  static const shimmer = Color(0x1AFFFFFF);
  // button
  static const deleteButt = Color(0xFFB71C1C);
  static const editButt = Color(0xFF0277BD);
}
