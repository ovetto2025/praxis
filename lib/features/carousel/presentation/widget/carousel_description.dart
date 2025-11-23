import 'package:flutter/material.dart';
import 'package:praxis/core/fonts/app_typography.dart';

class CarouselDescription extends StatelessWidget {
  final String text;
  const CarouselDescription({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: colors.primary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: AppTypography.body.copyWith(fontSize: 14, height: 1.45),
        ),
      ),
    );
    ;
  }
}
