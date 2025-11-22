import 'package:flutter_bloc/flutter_bloc.dart';
import 'map_event.dart';
import 'map_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState()) {
    on<LoadMarkers>((event, emit) async {
      final markers = <Marker>{
        Marker(
          markerId: const MarkerId("1"),
          position: const LatLng(45.4668, 9.1905),
        ),
      };

      emit(state.copyWith(markers: markers, loaded: true));
    });
  }
}
