import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../bloc/map/map_bloc.dart';
import '../bloc/map/map_event.dart';
import '../bloc/map/map_state.dart';

class MapScreenWidget extends StatefulWidget {
  const MapScreenWidget({super.key});

  @override
  State<MapScreenWidget> createState() => _MapScreenWidgetState();
}

class _MapScreenWidgetState extends State<MapScreenWidget> {
  @override
  void initState() {
    super.initState();
    context.read<MapBloc>().add(LoadMarkers());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, mapState) {
        return Stack(
          children: [
            /// 🌍 MAPPA
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(45.4668, 9.1905),
                zoom: 14,
              ),
              markers: mapState.markers,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
            ),

            /// 🔍 Barra di ricerca + Icona profilo
          ],
        );
      },
    );
  }
}
