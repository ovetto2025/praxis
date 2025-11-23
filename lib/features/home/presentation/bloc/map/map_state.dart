import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState {
  final Set<Marker> markers;
  final bool loaded;
  final LatLng? cameraTarget;

  MapState({this.markers = const {}, this.loaded = false, this.cameraTarget});

  MapState copyWith({
    Set<Marker>? markers,
    bool? loaded,
    LatLng? cameraTarget,
  }) {
    return MapState(
      markers: markers ?? this.markers,
      loaded: loaded ?? this.loaded,
      cameraTarget: cameraTarget ?? this.cameraTarget,
    );
  }
}
