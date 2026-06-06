// lib/screens/vendor/widgets/menu_item_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/menu_item.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/wellness_provider.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;
  final VoidCallback onAddToCart;
  final String vendorName;

  const MenuItemCard({
    super.key,
    required this.menuItem,
    required this.onAddToCart,
    required this.vendorName,
  });

  void _handleAddToCart(BuildContext context) {
    final cart = context.read<CartProvider>();

    if (cart.isFromDifferentVendor(menuItem.vendorId)) {
      _showClearCartDialog(context, cart);
    } else {
      onAddToCart();
    }
  }

  void _showClearCartDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Start a new order?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        content: Text(
          'Your cart has items from ${cart.vendorName ?? "another vendor"}. '
          'Adding this item will clear your current cart.',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Keep current cart',
              style: TextStyle(
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              cart.clearAndAdd(
                menuItem,
                vendorId: menuItem.vendorId,
                vendorName: vendorName,
              );
            },
            child: const Text(
              'Start new order',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wellness = context.watch<WellnessProvider>();
    final itemTags = [menuItem.name, ...menuItem.tags];
    final isConflicting = wellness.itemConflicts(itemTags);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        menuItem.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isConflicting
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₦${menuItem.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isConflicting
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                Text(
                  menuItem.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if (isConflicting)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFFE24B4A).withOpacity(0.3),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.block,
                              size: 11,
                              color: Color(0xFFE24B4A),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'May conflict',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFE24B4A),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ...menuItem.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getTagColor(tag),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: _getTagTextColor(tag),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Right side - Image and add button
          Stack(
            children: [
              Opacity(
                opacity: isConflicting ? 0.5 : 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: menuItem.imageUrl.isNotEmpty
                      ? Image.network(
                          menuItem.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder();
                          },
                        )
                      : _buildPlaceholder(),
                ),
              ),

              Positioned(
                bottom: 6,
                right: 6,
                child: GestureDetector(
                  onTap: () => _handleAddToCart(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isConflicting
                          ? AppColors.textTertiary
                          : AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isConflicting
                                      ? AppColors.textTertiary
                                      : AppColors.primary)
                                  .withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 40))),
    );
  }

  Color _getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'best seller':
        return const Color(0xFFFFEBEE);
      case 'heavy meal':
        return const Color(0xFFFFF3E0);
      case 'popular':
        return const Color(0xFFFFEBEE);
      case 'budget pick':
        return const Color(0xFFE8F5E9);
      case 'student special':
        return const Color(0xFFE3F2FD);
      default:
        return AppColors.background;
    }
  }

  Color _getTagTextColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'best seller':
        return const Color(0xFFC62828);
      case 'heavy meal':
        return AppColors.primary;
      case 'popular':
        return const Color(0xFFC62828);
      case 'budget pick':
        return const Color(0xFF2E7D32);
      case 'student special':
        return const Color(0xFF1565C0);
      default:
        return AppColors.textSecondary;
    }
  }
}
