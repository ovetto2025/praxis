import 'package:flutter/material.dart';

class PlaceImagesCarousel extends StatelessWidget {
  final List<String> images;

  const PlaceImagesCarousel({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              images[index],
              width: 275,
              height: 300,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
