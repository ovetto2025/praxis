import 'package:flutter/material.dart';

class CircularArrowButton extends StatelessWidget {
  final bool reversed;
  final VoidCallback? onPressed;
  final double size;

  const CircularArrowButton({
    super.key,
    this.reversed = false,
    this.onPressed,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onPressed, // TODO(logic)
      borderRadius: BorderRadius.circular(20),

      child: Container(
        width: size,
        height: size,

        decoration: BoxDecoration(
          color: colors.primary.withAlpha(128), // rosso 50%
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.primary, width: 2),
        ),

        alignment: Alignment.center,

        child: Icon(
          reversed ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,

          color: colors.primary,

          size: size * 0.45,
        ),
      ),
    );
  }
}
