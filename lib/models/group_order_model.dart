import 'package:cloud_firestore/cloud_firestore.dart';

enum GroupOrderStatus { active, locked, completed, cancelled }

class GroupMember {
  final String userId;
  final String name;
  final String? avatarUrl;
  final bool isHost;
  final bool isReady;
  final DateTime joinedAt;

  const GroupMember({
    required this.userId,
    required this.name,
    this.avatarUrl,
    this.isHost = false,
    this.isReady = false,
    required this.joinedAt,
  });

  factory GroupMember.fromMap(Map<String, dynamic> map) => GroupMember(
    userId: map['userId'],
    name: map['name'],
    avatarUrl: map['avatarUrl'],
    isHost: map['isHost'] ?? false,
    isReady: map['isReady'] ?? false,
    joinedAt: (map['joinedAt'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'name': name,
    'avatarUrl': avatarUrl,
    'isHost': isHost,
    'isReady': isReady,
    'joinedAt': Timestamp.fromDate(joinedAt),
  };

  GroupMember copyWith({bool? isReady}) => GroupMember(
    userId: userId,
    name: name,
    avatarUrl: avatarUrl,
    isHost: isHost,
    isReady: isReady ?? this.isReady,
    joinedAt: joinedAt,
  );
}

class GroupOrderItem {
  final String itemId;
  final String userId;
  final String userName;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;

  const GroupOrderItem({
    required this.itemId,
    required this.userId,
    required this.userName,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  factory GroupOrderItem.fromMap(Map<String, dynamic> map) => GroupOrderItem(
    itemId: map['itemId'],
    userId: map['userId'],
    userName: map['userName'],
    name: map['name'],
    price: (map['price'] as num).toDouble(),
    quantity: map['quantity'],
    imageUrl: map['imageUrl'],
  );

  Map<String, dynamic> toMap() => {
    'itemId': itemId,
    'userId': userId,
    'userName': userName,
    'name': name,
    'price': price,
    'quantity': quantity,
    'imageUrl': imageUrl,
  };
}

class GroupOrderModel {
  final String groupId;
  final String vendorId;
  final String vendorName;
  final String hostId;
  final String hostName;
  final GroupOrderStatus status;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final List<GroupMember> members;
  final List<GroupOrderItem> items;
  final double deliveryFee;
  final double serviceFee;

  const GroupOrderModel({
    required this.groupId,
    required this.vendorId,
    required this.vendorName,
    required this.hostId,
    required this.hostName,
    required this.status,
    required this.createdAt,
    this.expiresAt,
    required this.members,
    required this.items,
    this.deliveryFee = 800,
    this.serviceFee = 200,
  });

  factory GroupOrderModel.fromMap(String id, Map<String, dynamic> map) =>
      GroupOrderModel(
        groupId: id,
        vendorId: map['vendorId'],
        vendorName: map['vendorName'],
        hostId: map['hostId'],
        hostName: map['hostName'],
        status: GroupOrderStatus.values.firstWhere(
          (s) => s.name == map['status'],
          orElse: () => GroupOrderStatus.active,
        ),
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        expiresAt: map['expiresAt'] != null
            ? (map['expiresAt'] as Timestamp).toDate()
            : null,
        members: (map['members'] as List<dynamic>)
            .map((m) => GroupMember.fromMap(m))
            .toList(),
        items: (map['items'] as List<dynamic>)
            .map((i) => GroupOrderItem.fromMap(i))
            .toList(),
        deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 800,
        serviceFee: (map['serviceFee'] as num?)?.toDouble() ?? 200,
      );

  Map<String, dynamic> toMap() => {
    'vendorId': vendorId,
    'vendorName': vendorName,
    'hostId': hostId,
    'hostName': hostName,
    'status': status.name,
    'createdAt': Timestamp.fromDate(createdAt),
    'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
    'members': members.map((m) => m.toMap()).toList(),
    'items': items.map((i) => i.toMap()).toList(),
    'deliveryFee': deliveryFee,
    'serviceFee': serviceFee,
  };

  // ── Computed helpers 
  List<GroupOrderItem> itemsForUser(String userId) =>
      items.where((i) => i.userId == userId).toList();

  double get subtotal =>
      items.fold(0, (sum, i) => sum + (i.price * i.quantity));

  double get total => subtotal + deliveryFee + serviceFee;

  bool get isActive => status == GroupOrderStatus.active;
  bool get isLocked => status == GroupOrderStatus.locked;

  String get shareLink => 'munchies.app/g/$groupId';
}
