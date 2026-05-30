// lib/providers/wellness_provider.dart

import 'package:flutter/material.dart';
import '../models/wellness_model.dart';

class WellnessProvider extends ChangeNotifier {
  WellnessModel _wellness = const WellnessModel();

  WellnessModel get wellness => _wellness;
  bool get isEnabled => _wellness.isEnabled;
  bool get setupCompleted => _wellness.setupCompleted;
  List<String> get dietaryRestrictions => _wellness.dietaryRestrictions;
  List<String> get healthConditions => _wellness.healthConditions;

  // Called after setup flow completes
  void completeSetup({
    required List<String> dietaryRestrictions,
    required List<String> healthConditions,
    String? customRestriction,
  }) {
    _wellness = _wellness.copyWith(
      isEnabled: true,
      dietaryRestrictions: dietaryRestrictions,
      healthConditions: healthConditions,
      customRestriction: customRestriction,
      setupCompleted: true,
    );
    notifyListeners();
  }

  // Toggle on/off after setup is done
  void toggle() {
    _wellness = _wellness.copyWith(isEnabled: !_wellness.isEnabled);
    notifyListeners();
  }

  // Check if a menu item conflicts
  bool itemConflicts(List<String> itemTags) {
    if (!_wellness.isEnabled) return false;
    return _wellness.conflictsWith(itemTags);
  }

  // Reset everything
  void reset() {
    _wellness = const WellnessModel();
    notifyListeners();
  }
}
