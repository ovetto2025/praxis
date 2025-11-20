import 'package:flutter/material.dart';
import 'package:praxis/core/fonts/app_typography.dart';

class MainRedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const MainRedButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTypography.bodyBold.copyWith(
            fontSize: 16,
          ),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
