class UiState {
  final bool showRoutes;
  final bool showPlaces;

  UiState({this.showRoutes = false, this.showPlaces = false});

  UiState copyWith({bool? showRoutes, bool? showPlaces}) {
    return UiState(
      showRoutes: showRoutes ?? this.showRoutes,
      showPlaces: showPlaces ?? this.showPlaces,
    );
  }
}
