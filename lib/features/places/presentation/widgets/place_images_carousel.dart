import 'package:flutter/material.dart';

class PlaceImagesCarousel extends StatelessWidget {
  final List<String> images;

  const PlaceImagesCarousel({super.key, required this.images});

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
          final isNetwork = imagePath.startsWith('http');

          Widget imageWidget;
          if (isNetwork) {
            imageWidget = Image.network(
              imagePath,
              width: 275,
              height: 300,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  width: 275,
                  height: 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => _errorPlaceholder(),
            );
          } else {
            imageWidget = Image.asset(
              imagePath,
              width: 275,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _errorPlaceholder(),
            );
          }

          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageWidget,
          );
        },
      ),
    );
  }

  Widget _errorPlaceholder() {
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
  }
}
