import 'package:flutter/material.dart';
import 'package:praxis/core/fonts/app_typography.dart';
import 'package:praxis/core/theme/app_theme.dart';

class CarouselLocation extends StatelessWidget {
  final List<String> location;
  const CarouselLocation({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.7,
      ),
      itemCount: location.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(location[index], style: AppTypography.bodyBold),
            ),
          ),
        );
      },
    );
  }
}
