class PlaceModel {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final double latitude;
  final double longitude;

  const PlaceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.latitude,
    required this.longitude,
  });
}
