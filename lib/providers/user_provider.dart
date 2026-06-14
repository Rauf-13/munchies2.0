// lib/providers/user_provider.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isVendor => _user?.isVendor ?? false;
  bool get isCustomer => _user?.isCustomer ?? true;

  // ── SIGN UP ──
  Future<bool> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = credential.user!.uid;
      final newUser = UserModel(
        id: uid,
        fullName: fullName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        role: UserRole.customer,
      );

      await _db.collection('users').doc(uid).set(newUser.toMap());
      _user = newUser;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _friendlyError(e.code);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── LOG IN ──
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _error = null;
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await _loadUserFromFirestore(credential.user!.uid);

      return true;
    } on FirebaseAuthException catch (e) {
      _error = _friendlyError(e.code);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── LOG OUT ──
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  // ── PERSIST AUTH ──
  Future<void> checkAuthState() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      await _loadUserFromFirestore(firebaseUser.uid);
    }
  }

  // ── UPDATE PROFILE ──
  Future<void> updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? profileImageUrl,
    UserRole? role,
  }) async {
    if (_user == null) return;
    _user = _user!.copyWith(
      fullName: fullName,
      email: email,
      phone: phone,
      profileImageUrl: profileImageUrl,
      role: role,
    );

    await _db.collection('users').doc(_user!.id).update({
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      if (role != null) 'role': role.name,
    });

    notifyListeners();
  }

  // ── FORGOT PASSWORD ──
  Future<bool> sendPasswordReset(String email) async {
    _setLoading(true);
    _error = null;
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _friendlyError(e.code);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── INTERNAL ──
  Future<void> _loadUserFromFirestore(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      _user = UserModel.fromMap(doc.id, doc.data()!);
      notifyListeners();
    }
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Try again.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection. Check your network.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
