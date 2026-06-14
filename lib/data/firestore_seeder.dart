// lib/data/firestore_seeder.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dummy_vendors.dart';
import 'dummy_menu_items.dart';

class FirestoreSeeder {
  static final _db = FirebaseFirestore.instance;

  static Future<void> seedAll() async {
    print('🌱 Starting seed...');
    try {
      await _seedVendors();
      await _seedMenuItems();
      print('✅ Firestore seeded successfully');
    } catch (e) {
      print('❌ Seed failed: $e');
    }
  }

  static Future<void> _seedVendors() async {
    final batch = _db.batch();
    for (final vendor in dummyVendors) {
      final ref = _db.collection('vendors').doc(vendor.id);
      batch.set(ref, {
        'id': vendor.id,
        'name': vendor.name,
        'category': vendor.category,
        'rating': vendor.rating,
        'reviewCount': vendor.reviewCount,
        'distance': vendor.distance,
        'deliveryTime': vendor.deliveryTime,
        'imageUrl': vendor.imageUrl,
        'isPopular': vendor.isPopular,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
    print('✅ Vendors seeded');
  }

  static Future<void> _seedMenuItems() async {
    final batch = _db.batch();
    for (final item in dummyMenuItems) {
      final ref = _db.collection('menu_items').doc(item.id);
      batch.set(ref, {
        'id': item.id,
        'vendorId': item.vendorId,
        'name': item.name,
        'description': item.description,
        'price': item.price,
        'category': item.category,
        'imageUrl': item.imageUrl,
        'tags': item.tags,
        'isAvailable': item.isAvailable,
        'preparationTime': item.preparationTime,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
    print('✅ Menu items seeded');
  }
}
