import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ui/ui_bloc.dart';
import '../bloc/ui/ui_event.dart';
import '../bloc/map/map_bloc.dart';
import '../bloc/map/map_event.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/features/places/data/places_mock.dart';
import 'package:praxis/features/places/models/place_model.dart';
import 'dart:math';

class PlaceSheet extends StatelessWidget {
  const PlaceSheet({super.key});

  double _distanceMeters(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000.0; // metri
    double dLat = _deg2rad(lat2 - lat1);
    double dLon = _deg2rad(lon2 - lon1);
    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _deg2rad(double deg) => deg * pi / 180.0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent <= 0.16) {
          context.read<UiBloc>().add(HideSheets());
        }
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.15,
        maxChildSize: 0.85,
        builder: (BuildContext context, ScrollController scrollController) {
          try {
            final mapState = context.watch<MapBloc>().state;

            // Verifico che placesMock non sia vuoto
            if (placesMock.isEmpty) {
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  color: Color(0xFFF6F4FB),
                ),
                child: const Center(child: Text('Nessun luogo disponibile')),
              );
            }

            // centro di riferimento per distanza
            final reference = mapState.cameraTarget != null
                ? PlaceModel(
                    id: 'ref',
                    title: 'ref',
                    description: '',
                    images: const [],
                    latitude: mapState.cameraTarget!.latitude,
                    longitude: mapState.cameraTarget!.longitude,
                  )
                : placesMock.first;

            // calcoliamo distanze
            final List<(PlaceModel place, double meters)> withDistances = [
              for (final p in placesMock)
                if (p.id != reference.id)
                  (
                    p,
                    _distanceMeters(
                      reference.latitude,
                      reference.longitude,
                      p.latitude,
                      p.longitude,
                    ),
                  ),
            ];

            // ordina per distanza crescente
            withDistances.sort((a, b) => a.$2.compareTo(b.$2));

            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                color: Color(0xFFF6F4FB),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Luoghi Vicini",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (withDistances.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Nessun luogo trovato'),
                    )
                  else
                    for (final tuple in withDistances.take(5))
                      _placeCard(context, tuple.$1, tuple.$2),
                ],
              ),
            );
          } catch (e) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                color: Color(0xFFF6F4FB),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Errore: ${e.toString()}'),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _placeCard(BuildContext context, PlaceModel place, double meters) {
    final passi = (meters * 1.43)
        .round(); // stima passi (media ~0.7m a passo) => metri/0.7 ~ 1.43
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          place.title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        Text(
          "Distanza: ${meters.round()} m - $passi passi",
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [for (final img in place.images.take(3)) _imageBox(img)],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  context.read<MapBloc>().add(FocusOnPlace(place.id));
                },
                child: const Text("Indicazioni"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  GoRouter.of(context).push('/place/${place.id}');
                },
                child: const Text("Info"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _imageBox(String path) {
    final isNetwork = path.startsWith('http');
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 140,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: isNetwork
            ? Image.network(
                path,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _errorIcon(),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              )
            : Image.asset(
                path,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _errorIcon(),
              ),
      ),
    );
  }

  Widget _errorIcon() {
    return const Center(
      child: Icon(Icons.broken_image, color: Colors.grey, size: 32),
    );
  }
}
