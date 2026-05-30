import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { customer, vendor }

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;
  final String? profileImageUrl;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.profileImageUrl,
  });

  String get firstName => fullName.split(' ').first;
  bool get isVendor => role == UserRole.vendor;
  bool get isCustomer => role == UserRole.customer;

  factory UserModel.fromMap(String id, Map<String, dynamic> map) => UserModel(
        id: id,
        fullName: map['fullName'] ?? '',
        email: map['email'] ?? '',
        phone: map['phone'] ?? '',
        role: map['role'] == 'vendor' ? UserRole.vendor : UserRole.customer,
        profileImageUrl: map['profileImageUrl'],
      );

  Map<String, dynamic> toMap() => {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'role': role.name,
        'profileImageUrl': profileImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      };

  UserModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? profileImageUrl,
    UserRole? role,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}