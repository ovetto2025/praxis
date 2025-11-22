import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState {
  final Set<Marker> markers;
  final bool loaded;

  MapState({this.markers = const {}, this.loaded = false});

  MapState copyWith({Set<Marker>? markers, bool? loaded}) {
    return MapState(
      markers: markers ?? this.markers,
      loaded: loaded ?? this.loaded,
    );
  }
}
