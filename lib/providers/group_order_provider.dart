import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group_order_model.dart';
import '../models/cart_item.dart';
import '../models/user_model.dart';

class GroupOrderProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  GroupOrderModel? _groupOrder;
  StreamSubscription<DocumentSnapshot>? _subscription;
  String? _lastActivityMessage;
  bool _isLoading = false;
  String? _error;

  // ── Public getters ───────────────────────────────────────────
  GroupOrderModel? get groupOrder => _groupOrder;
  bool get isInGroupOrder => _groupOrder != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get lastActivityMessage => _lastActivityMessage;

  bool isHost(String userId) => _groupOrder?.hostId == userId;
  bool isMember(String userId) =>
      _groupOrder?.members.any((m) => m.userId == userId) ?? false;

  // ── CREATE (host starts a group order) ───────────────────────
  Future<String?> createGroupOrder({
    required UserModel user,
    required String vendorId,
    required String vendorName,
    required List<CartItem> cartItems,
  }) async {
    _setLoading(true);
    try {
      final docRef = _db.collection('group_orders').doc();
      final now = DateTime.now();

      final groupItems = cartItems
          .map(
            (c) => GroupOrderItem(
              itemId: c.menuItem.id,
              userId: user.id,
              userName: user.firstName,
              name: c.menuItem.name,
              price: c.menuItem.price.toDouble(),
              quantity: c.quantity,
              imageUrl: c.menuItem.imageUrl,
            ),
          )
          .toList();

      final model = GroupOrderModel(
        groupId: docRef.id,
        vendorId: vendorId,
        vendorName: vendorName,
        hostId: user.id,
        hostName: user.firstName,
        status: GroupOrderStatus.active,
        createdAt: now,
        expiresAt: now.add(const Duration(minutes: 15)),
        members: [
          GroupMember(
            userId: user.id,
            name: user.firstName,
            isHost: true,
            joinedAt: now,
          ),
        ],
        items: groupItems,
      );

      await docRef.set(model.toMap());
      _listenToGroup(docRef.id);
      return docRef.id;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // ── JOIN (guest joins via link) ──────────────────────────────
  Future<bool> joinGroupOrder({
    required String groupId,
    required UserModel user,
  }) async {
    _setLoading(true);
    try {
      final doc = await _db.collection('group_orders').doc(groupId).get();
      if (!doc.exists) throw Exception('Group order not found');

      final model = GroupOrderModel.fromMap(doc.id, doc.data()!);
      if (!model.isActive)
        throw Exception('This group order is no longer active');
      if (isMember(user.id)) {
        _listenToGroup(groupId);
        return true;
      }

      final newMember = GroupMember(
        userId: user.id,
        name: user.firstName,
        joinedAt: DateTime.now(),
      );

      await _db.collection('group_orders').doc(groupId).update({
        'members': FieldValue.arrayUnion([newMember.toMap()]),
      });

      _listenToGroup(groupId);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── ADD ITEM (any member, their own items only) ──────────────
  Future<void> addItem(GroupOrderItem item) async {
    if (_groupOrder == null) return;
    try {
      // Check if item already exists for this user → increase qty
      final existing = _groupOrder!.items
          .where((i) => i.itemId == item.itemId && i.userId == item.userId)
          .firstOrNull;

      if (existing != null) {
        final updated = _groupOrder!.items.map((i) {
          if (i.itemId == item.itemId && i.userId == item.userId) {
            return GroupOrderItem(
              itemId: i.itemId,
              userId: i.userId,
              userName: i.userName,
              name: i.name,
              price: i.price,
              quantity: i.quantity + 1,
              imageUrl: i.imageUrl,
            );
          }
          return i;
        }).toList();

        await _updateItems(updated);
      } else {
        await _db.collection('group_orders').doc(_groupOrder!.groupId).update({
          'items': FieldValue.arrayUnion([item.toMap()]),
        });
      }

      _setActivity('${item.userName} added ${item.name}');
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ── REMOVE ITEM ──────────────────────────────────────────────
  Future<void> removeItem(GroupOrderItem item) async {
    if (_groupOrder == null) return;
    try {
      final updated = _groupOrder!.items.where((i) => i != item).toList();
      await _updateItems(updated);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ── LOCK ORDER (host only) ───────────────────────────────────
  Future<void> lockOrder() async {
    if (_groupOrder == null) return;
    await _db.collection('group_orders').doc(_groupOrder!.groupId).update({
      'status': GroupOrderStatus.locked.name,
    });
  }

  // ── MARK READY (member is done adding) ──────────────────────
  Future<void> markReady(String userId) async {
    if (_groupOrder == null) return;
    final updated = _groupOrder!.members.map((m) {
      if (m.userId == userId) return m.copyWith(isReady: true);
      return m;
    }).toList();

    await _db.collection('group_orders').doc(_groupOrder!.groupId).update({
      'members': updated.map((m) => m.toMap()).toList(),
    });
  }

  // ── LEAVE / DISBAND ──────────────────────────────────────────
  Future<void> leaveGroup(String userId) async {
    if (_groupOrder == null) return;
    if (_groupOrder!.hostId == userId) {
      // Host leaving = cancel the whole order
      await _db.collection('group_orders').doc(_groupOrder!.groupId).update({
        'status': GroupOrderStatus.cancelled.name,
      });
    } else {
      final updatedMembers = _groupOrder!.members
          .where((m) => m.userId != userId)
          .toList();
      final updatedItems = _groupOrder!.items
          .where((i) => i.userId != userId)
          .toList();
      await _db.collection('group_orders').doc(_groupOrder!.groupId).update({
        'members': updatedMembers.map((m) => m.toMap()).toList(),
        'items': updatedItems.map((i) => i.toMap()).toList(),
      });
    }
    _clear();
  }

  // ── COMPLETE (after host checks out) ────────────────────────
  Future<void> completeOrder() async {
    if (_groupOrder == null) return;
    await _db.collection('group_orders').doc(_groupOrder!.groupId).update({
      'status': GroupOrderStatus.completed.name,
    });
    _clear();
  }

  // ── INTERNAL ─────────────────────────────────────────────────
  void _listenToGroup(String groupId) {
    _subscription?.cancel();
    _subscription = _db
        .collection('group_orders')
        .doc(groupId)
        .snapshots()
        .listen((snap) {
          if (snap.exists) {
            _groupOrder = GroupOrderModel.fromMap(snap.id, snap.data()!);
            notifyListeners();
          }
        });
  }

  Future<void> _updateItems(List<GroupOrderItem> items) async {
    await _db.collection('group_orders').doc(_groupOrder!.groupId).update({
      'items': items.map((i) => i.toMap()).toList(),
    });
  }

  void _setActivity(String message) {
    _lastActivityMessage = message;
    notifyListeners();
    Future.delayed(const Duration(seconds: 4), () {
      _lastActivityMessage = null;
      notifyListeners();
    });
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _clear() {
    _subscription?.cancel();
    _groupOrder = null;
    _lastActivityMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
