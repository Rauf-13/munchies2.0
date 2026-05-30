import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/menu_item.dart';

class PopularMealCard extends StatelessWidget {
  final MenuItem meal;
  final VoidCallback onAddToCart;

  static const _imageSize = 80.0;

  const PopularMealCard({
    super.key,
    required this.meal,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          // Food Image (circular)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: meal.imageUrl.isNotEmpty
                ? Image.network(
                    meal.imageUrl,
                    width: _imageSize,
                    height: _imageSize,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildPlaceholder();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder();
                    },
                  )
                : _buildPlaceholder(),
          ),

          const SizedBox(width: 16),

          // Meal Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Iya Basira\'s Kitchen', // We'll make this dynamic later
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '₦${meal.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Add Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onAddToCart,
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: _imageSize,
      height: _imageSize,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 32))),
    );
  }
}
