import 'package:flutter/material.dart';

class PlaceImagesCarousel extends StatelessWidget {
  final List<String> images;

  const PlaceImagesCarousel({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final imagePath = images[index];

          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 275,
              height: 300,
              fit: BoxFit.cover,

              // 🔥 PLACEHOLDER IN CASO DI ERRORE
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 275,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 48,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
