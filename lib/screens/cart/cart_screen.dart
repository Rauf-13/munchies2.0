import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/group_order_provider.dart';
import 'cart_format.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/cart_summary.dart';
import 'widgets/empty_cart_view.dart';
import 'widgets/group_order_banner.dart';
import '../checkout/checkout_screen.dart';
import '../group_order/group_cart_screen.dart';

class CartScreen extends StatelessWidget {
  final String? vendorName;
  final bool showBackButton;

  const CartScreen({super.key, this.vendorName, this.showBackButton = true});

  static const _scaffoldBg = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final group = context.watch<GroupOrderProvider>();
    final items = cart.items;

    return Scaffold(
      backgroundColor: _scaffoldBg,
      body: SafeArea(
        child: items.isEmpty
            ? const EmptyCartView()
            : Column(
                children: [
                  _buildHeader(context),
                  _buildVendorLabel(cart.vendorName ?? vendorName),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),

                          // ── Group order banner ──────────────
                          const GroupOrderBanner(),

                          // ── Cart items ──────────────────────
                          ...items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CartItemCard(item: item),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const CartSummary(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: items.isEmpty
          ? null
          : _buildPlaceOrderBar(context, cart, group),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: _scaffoldBg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (showBackButton)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  size: 26,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            )
          else
            const SizedBox(width: 44),
          const Expanded(
            child: Text(
              'Your Cart',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildVendorLabel(String? name) {
    if (name == null || name.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.storefront_outlined,
              size: 18,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderBar(
    BuildContext context,
    CartProvider cart,
    GroupOrderProvider group,
  ) {
    // If already in a group order, button opens the group cart instead
    final inGroupOrder = group.isInGroupOrder;

    return Container(
      color: _scaffoldBg,
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16 + MediaQuery.paddingOf(context).bottom,
      ),
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (inGroupOrder) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GroupCartScreen()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CheckoutScreen()),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                inGroupOrder ? 'View Group Order' : 'Place Order',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                formatNaira(cart.total),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
