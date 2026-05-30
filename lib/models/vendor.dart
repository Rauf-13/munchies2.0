class Vendor {
  final String id;
  final String name;
  final String category;
  final double rating;
  final int reviewCount;
  final String distance;
  final String deliveryTime;
  final String imageUrl;
  final bool isPopular;

  Vendor({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.deliveryTime,
    required this.imageUrl,
    this.isPopular = false,
  });
}
