import 'package:flutter/material.dart';

class PlaceDescriptionBox extends StatelessWidget {
  final String text;

  const PlaceDescriptionBox({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colors.primary, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          height: 1.45,
        ),
      ),
    );
  }
}
