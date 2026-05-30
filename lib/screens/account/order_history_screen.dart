import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../cart/cart_format.dart';

enum OrderStatus { delivered, cancelled, inProgress }

class OrderHistoryItem {
  final String id;
  final String vendorName;
  final String vendorImage;
  final List<String> items;
  final double total;
  final OrderStatus status;
  final String date;
  final int itemCount;

  const OrderHistoryItem({
    required this.id,
    required this.vendorName,
    required this.vendorImage,
    required this.items,
    required this.total,
    required this.status,
    required this.date,
    required this.itemCount,
  });
}

const List<OrderHistoryItem> _dummyOrders = [
  OrderHistoryItem(
    id: 'ORD-8821',
    vendorName: 'Mama Titi Kitchen',
    vendorImage:
        'https://images.unsplash.com/photo-1555244162-803834f70033?w=400',
    items: ['Jollof Rice + Chicken', 'Zobo Drink'],
    total: 3800,
    status: OrderStatus.delivered,
    date: 'Today, 1:45 PM',
    itemCount: 2,
  ),
  OrderHistoryItem(
    id: 'ORD-8814',
    vendorName: 'Campus Bites',
    vendorImage:
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400',
    items: ['Fried Rice', 'Moi Moi', 'Fanta'],
    total: 5200,
    status: OrderStatus.delivered,
    date: 'Yesterday, 6:10 PM',
    itemCount: 3,
  ),
  OrderHistoryItem(
    id: 'ORD-8801',
    vendorName: 'Spicy Corner',
    vendorImage:
        'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400',
    items: ['Shawarma x2', 'Chapman'],
    total: 4100,
    status: OrderStatus.cancelled,
    date: 'Mon, Apr 14',
    itemCount: 3,
  ),
  OrderHistoryItem(
    id: 'ORD-8796',
    vendorName: 'Mama Titi Kitchen',
    vendorImage:
        'https://images.unsplash.com/photo-1555244162-803834f70033?w=400',
    items: ['Egusi Soup + Eba', 'Goat Meat x2'],
    total: 6500,
    status: OrderStatus.delivered,
    date: 'Sun, Apr 13',
    itemCount: 2,
  ),
  OrderHistoryItem(
    id: 'ORD-8780',
    vendorName: 'Quick Grills',
    vendorImage:
        'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?w=400',
    items: ['Suya Wrap', 'Pepsi'],
    total: 2900,
    status: OrderStatus.delivered,
    date: 'Fri, Apr 11',
    itemCount: 2,
  ),
];

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<OrderHistoryItem> _filtered(OrderStatus? status) {
    if (status == null) return _dummyOrders;
    return _dummyOrders.where((o) => o.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryOrange,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryOrange,
          indicatorWeight: 2.5,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Delivered'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _OrderList(orders: _filtered(null)),
          _OrderList(orders: _filtered(OrderStatus.delivered)),
          _OrderList(orders: _filtered(OrderStatus.cancelled)),
        ],
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<OrderHistoryItem> orders;

  const _OrderList({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                color: AppColors.primaryOrange,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No orders here yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your order history will appear here',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (_, i) => _OrderCard(order: orders[i]),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderHistoryItem order;

  const _OrderCard({required this.order});

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
      case OrderStatus.inProgress:
        return AppColors.primaryOrange;
    }
  }

  String get _statusLabel {
    switch (order.status) {
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.inProgress:
        return 'In Progress';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    order.vendorImage,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 48,
                      height: 48,
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      child: const Icon(
                        Icons.storefront_rounded,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.vendorName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),
            Text(
              order.items.join(' · '),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.itemCount} item${order.itemCount > 1 ? 's' : ''} · ${formatNaira(order.total)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (order.status == OrderStatus.delivered)
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Reorder coming soon'),
                          backgroundColor: AppColors.primaryOrange,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Reorder',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
