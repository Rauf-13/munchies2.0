import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/group_order_model.dart';
import '../../../screens/cart/cart_format.dart';

class GroupTotalBar extends StatelessWidget {
  final GroupOrderModel order;
  final bool isHost;
  final VoidCallback onCheckout;

  const GroupTotalBar({
    super.key,
    required this.order,
    required this.isHost,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x12000000),
              blurRadius: 20,
              offset: Offset(0, -4))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Price breakdown
          _PriceRow(label: 'Subtotal', value: order.subtotal),
          const SizedBox(height: 6),
          _PriceRow(
              label: 'Delivery',
              value: order.deliveryFee,
              secondary: true),
          _PriceRow(
              label: 'Service fee',
              value: order.serviceFee,
              secondary: true),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF0F0F0)),
          ),
          _PriceRow(label: 'Total', value: order.total, bold: true),
          const SizedBox(height: 14),

          // CTA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isHost && order.isActive ? onCheckout : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor:
                    AppColors.border,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                isHost
                    ? 'Checkout for everyone'
                    : 'Waiting for host...',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isHost ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool secondary;
  final bool bold;

  const _PriceRow({
    required this.label,
    required this.value,
    this.secondary = false,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: secondary ? 13 : 14,
            color: secondary
                ? AppColors.textSecondary
                : AppColors.textPrimary,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          formatNaira(value),
          style: TextStyle(
            fontSize: secondary ? 13 : 14,
            color: secondary
                ? AppColors.textSecondary
                : AppColors.textPrimary,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}