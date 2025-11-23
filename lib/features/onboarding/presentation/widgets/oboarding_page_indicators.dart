import 'package:flutter/material.dart';
import 'package:praxis/core/theme/app_theme.dart'; // ← per usare AppTheme.hintText

class OnboardingPageIndicators extends StatelessWidget {
  final int currentIndex;
  final int totalPages;

  const OnboardingPageIndicators({
    super.key,
    required this.currentIndex,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,

      children: List.generate(
        totalPages,
            (index) => Padding(
          // ✅ MODIFICA 1: padding 8
          padding: const EdgeInsets.all(8),  // <— MODIFICATO QUI

          child: _Dot(
            filled: index == currentIndex,

            // colore selezionato
            activeColor: colors.primary,

            // colore non selezionato → hintText dal tuo tema
            inactiveColor: AppTheme.hintText, // <— MODIFICATO QUI
          ),
        ),
      ),
    );
  }
}


/// Dot singolo --------------------------------------------------------------
class _Dot extends StatelessWidget {
  final bool filled;
  final Color activeColor;
  final Color inactiveColor;

  const _Dot({
    required this.filled,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? activeColor : inactiveColor,
      ),
    );
  }
}
