import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/features/places/data/places_mock.dart';
import 'package:praxis/features/places/models/place_model.dart';

// Widgets modulari
import 'package:praxis/features/places/presentation/widgets/place_images_carousel.dart';
import 'package:praxis/features/places/presentation/widgets/place_description_box.dart';
import 'package:praxis/shared/widgets/main_red_button.dart';

// Back button tuo widget
import 'package:praxis/features/onboarding/presentation/widgets/circular_arrow_button_widget.dart';

// Typography ufficiale
import 'package:praxis/core/fonts/app_typography.dart';

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ROW CON BACK BUTTON + TITOLO
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularArrowButton(
                    reversed: true,
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      place.title,
                      style: AppTypography.title.copyWith(
                        color: Colors.black,
                        fontSize: 32,   // manteniamo la dimensione esatta del Figma
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // IMMAGINI
              PlaceImagesCarousel(images: place.images),

              const SizedBox(height: 8),

              // DESCRIZIONE
              PlaceDescriptionBox(text: place.description),

              const SizedBox(height: 8),

              // BUTTON "Indicazioni"
              Center(
                child: MainRedButton(
                  label: "Indicazioni",
                  onPressed: () {
                    // TODO
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
