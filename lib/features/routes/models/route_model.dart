class RouteModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<String> placeIds;

  const RouteModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.placeIds,
  });
}
