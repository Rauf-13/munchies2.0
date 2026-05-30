// lib/models/wellness_model.dart

class WellnessModel {
  final bool isEnabled;
  final List<String> dietaryRestrictions;
  final List<String> healthConditions;
  final String? customRestriction;
  final bool setupCompleted;

  const WellnessModel({
    this.isEnabled = false,
    this.dietaryRestrictions = const [],
    this.healthConditions = const [],
    this.customRestriction,
    this.setupCompleted = false,
  });

  WellnessModel copyWith({
    bool? isEnabled,
    List<String>? dietaryRestrictions,
    List<String>? healthConditions,
    String? customRestriction,
    bool? setupCompleted,
  }) {
    return WellnessModel(
      isEnabled: isEnabled ?? this.isEnabled,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      healthConditions: healthConditions ?? this.healthConditions,
      customRestriction: customRestriction ?? this.customRestriction,
      setupCompleted: setupCompleted ?? this.setupCompleted,
    );
  }

  /// Returns true if a menu item name/tags conflict with the user's restrictions.
  /// Pass in the item's name and any relevant tags/ingredients as a list of strings.
  bool conflictsWith(List<String> itemTags) {
    final lower = itemTags.map((t) => t.toLowerCase()).toList();

    const restrictionMap = {
      'No Beef': ['beef', 'suya', 'burger', 'steak'],
      'No Pork': ['pork', 'bacon', 'ham'],
      'No Dairy': ['milk', 'cheese', 'butter', 'cream', 'yoghurt', 'dairy'],
      'No Gluten': ['bread', 'wheat', 'pasta', 'flour', 'noodle'],
      'No Nuts': ['peanut', 'groundnut', 'nut', 'almond', 'cashew'],
      'No Spicy': ['spicy', 'pepper', 'chilli', 'hot sauce'],
      'No Red Meat': ['beef', 'lamb', 'goat', 'pork', 'suya'],
      'No Fish': ['fish', 'catfish', 'tilapia', 'shrimp', 'prawn', 'seafood'],
    };

    for (final restriction in dietaryRestrictions) {
      final keywords = restrictionMap[restriction] ?? [];
      for (final keyword in keywords) {
        if (lower.any((tag) => tag.contains(keyword))) {
          return true;
        }
      }
    }
    return false;
  }

  Map<String, dynamic> toMap() => {
        'isEnabled': isEnabled,
        'dietaryRestrictions': dietaryRestrictions,
        'healthConditions': healthConditions,
        'customRestriction': customRestriction,
        'setupCompleted': setupCompleted,
      };

  factory WellnessModel.fromMap(Map<String, dynamic> map) => WellnessModel(
        isEnabled: map['isEnabled'] ?? false,
        dietaryRestrictions: List<String>.from(map['dietaryRestrictions'] ?? []),
        healthConditions: List<String>.from(map['healthConditions'] ?? []),
        customRestriction: map['customRestriction'],
        setupCompleted: map['setupCompleted'] ?? false,
      );
}