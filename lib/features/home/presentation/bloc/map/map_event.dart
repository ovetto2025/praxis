abstract class MapEvent {}

class LoadMarkers extends MapEvent {}

class FocusOnPlace extends MapEvent {
  final String placeId;
  FocusOnPlace(this.placeId);
}
