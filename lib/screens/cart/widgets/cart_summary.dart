import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/cart_provider.dart';
import '../cart_format.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    const delivery = CartProvider.deliveryFee;
    const service = CartProvider.serviceFee;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _row('Subtotal', cart.subtotal, isGrey: true),
          const SizedBox(height: 12),
          _row('Delivery Fee', delivery, isGrey: true),
          const SizedBox(height: 12),
          _row('Service Fee', service, isGrey: true),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: List.generate(
                40,
                (index) => Expanded(
                  child: Container(
                    height: 1,
                    color: index.isEven
                        ? const Color(0xFFDDDDDD)
                        : Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          _row('Total', cart.total, isTotal: true),
        ],
      ),
    );
  }

  Widget _row(
    String label,
    double value, {
    bool isGrey = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: isGrey ? const Color(0xFF999999) : AppColors.textPrimary,
          ),
        ),
        Text(
          formatNaira(value),
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
