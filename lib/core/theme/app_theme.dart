import 'package:flutter/material.dart';
import 'package:praxis/core/fonts/app_typography.dart';

class AppTheme {
  static const Color backgroundColor = Colors.white; // 👈 globale bianco
  static const Color primaryColor = Color(0xFFB01E21);
  static const Color secondaryButtonColor = Color(0xFF5A805A);
  static const Color textColor = Color(0xFF000000);
  static const Color hintText = Color(0xFFAFB1B6);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor, // 👈 ECCO LA MODIFICA IMPORTANTE

    colorScheme: ColorScheme.light(
      primary: primaryColor,
      surface: backgroundColor, // 👈 le superfici ereditano lo sfondo bianco
      secondary: secondaryButtonColor,
    ),

    textTheme: TextTheme(
      displayLarge: AppTypography.title,
      headlineSmall: AppTypography.subtitle,
      bodyMedium: AppTypography.body,
      labelLarge: AppTypography.bodyBold,
    ),
  );
}
