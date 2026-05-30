class MenuItem {
  final String id;
  final String vendorId;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final List<String> tags; // "Best seller", "Heavy meal", "Popular", etc.
  final bool isAvailable;
  final String preparationTime;

  MenuItem({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.tags = const [],
    this.isAvailable = true,
    this.preparationTime = '15 min',
  });
}
