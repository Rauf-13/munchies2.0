import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/group_order_model.dart';
import '../../../screens/cart/cart_format.dart';

class MemberItemsSection extends StatelessWidget {
  final GroupMember member;
  final List<GroupOrderItem> items;
  final bool isCurrentUser;
  final bool isLocked;
  final void Function(GroupOrderItem) onRemove;

  const MemberItemsSection({
    super.key,
    required this.member,
    required this.items,
    required this.isCurrentUser,
    required this.isLocked,
    required this.onRemove,
  });

  double get _memberTotal =>
      items.fold(0, (sum, i) => sum + (i.price * i.quantity));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCurrentUser
            ? Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1.5,
              )
            : null,
        boxShadow: const [
          BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Text(
                  isCurrentUser ? 'Your items' : member.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isCurrentUser
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
                if (member.isHost) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'host',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (items.isNotEmpty)
                  Text(
                    formatNaira(_memberTotal),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),

          // ── Items ────────────────────────────────────────
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                isCurrentUser
                    ? 'Go back and add your items'
                    : '${member.name} is still choosing...',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...items.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              final isLast = idx == items.length - 1;

              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: _GroupItemRow(
                      item: item,
                      canEdit: isCurrentUser && !isLocked,
                      onRemove: () => onRemove(item),
                    ),
                  ),
                  if (!isLast)
                    const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Color(0xFFF0F0F0)),
                ],
              );
            }),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _GroupItemRow extends StatelessWidget {
  final GroupOrderItem item;
  final bool canEdit;
  final VoidCallback onRemove;

  const _GroupItemRow({
    required this.item,
    required this.canEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Food image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl ?? '',
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.fastfood_outlined,
                    size: 20, color: AppColors.textTertiary),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name + price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.quantity} × ${formatNaira(item.price)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Item total
          Text(
            formatNaira(item.price * item.quantity),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          // Remove (own items only)
          if (canEdit) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close_rounded,
                    size: 14, color: AppColors.error),
              ),
            ),
          ],
        ],
      ),
    );
  }
}