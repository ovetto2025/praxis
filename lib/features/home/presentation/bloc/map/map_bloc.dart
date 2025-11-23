import 'package:flutter_bloc/flutter_bloc.dart';
import 'map_event.dart';
import 'map_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:praxis/features/places/data/places_mock.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState()) {
    on<LoadMarkers>((event, emit) async {
      final markers = <Marker>{
        for (final place in placesMock)
          Marker(
            markerId: MarkerId(place.id),
            position: LatLng(place.latitude, place.longitude),
            infoWindow: InfoWindow(title: place.title),
          ),
      };
      emit(state.copyWith(markers: markers, loaded: true));
    });

    on<FocusOnPlace>((event, emit) async {
      final place = placesMock.firstWhere((p) => p.id == event.placeId);
      emit(
        state.copyWith(cameraTarget: LatLng(place.latitude, place.longitude)),
      );
    });
  }
}
