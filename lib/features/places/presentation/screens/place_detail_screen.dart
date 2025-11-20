import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/features/places/data/places_mock.dart';
import 'package:praxis/features/places/models/place_model.dart';

// Widgets modulari
import 'package:praxis/features/places/presentation/widgets/place_images_carousel.dart';
import 'package:praxis/features/places/presentation/widgets/place_description_box.dart';
import 'package:praxis/shared/widgets/main_red_button.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const String routeName = '/place/:id';

  final String placeId;

  const PlaceDetailScreen({
    super.key,
    required this.placeId,
  });

  @override
  Widget build(BuildContext context) {
    final PlaceModel place =
    placesMock.firstWhere((p) => p.id == placeId);

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BACK BUTTON
              InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.primary, width: 2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: colors.primary,
                    size: 22,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // TITLE
              Text(
                place.title,
                style: textTheme.displayLarge?.copyWith(
                  fontSize: 32,
                  color: colors.primary,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 16),

              // IMAGES CAROUSEL
              PlaceImagesCarousel(images: place.images),

              const SizedBox(height: 8),

              // DESCRIPTION BOX
              PlaceDescriptionBox(text: place.description),

              const SizedBox(height: 8),

              // BUTTON
              Center(
                child: MainRedButton(
                  label: "Indicazioni",
                  onPressed: () {
                    // TODO: Collegamento alla mappa
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
