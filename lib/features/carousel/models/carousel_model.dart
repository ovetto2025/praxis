class CarouselModel {
  final int numberId;
  final String title;
  final String description;
  final List<String> location;
  final List<String> locationId; //for sending to the different locations

  const CarouselModel({
    required this.numberId,
    required this.title,
    required this.description,
    required this.location,
    required this.locationId,
  });
}
