import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/group_order_provider.dart';
import '../../../providers/user_provider.dart';
import '../../group_order/group_cart_screen.dart';

class GroupOrderBanner extends StatefulWidget {
  const GroupOrderBanner({super.key});

  @override
  State<GroupOrderBanner> createState() => _GroupOrderBannerState();
}

class _GroupOrderBannerState extends State<GroupOrderBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _expand;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expand = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _startGroupOrder(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final user = context.read<UserProvider>().user!;
    final group = context.read<GroupOrderProvider>();

    final groupId = await group.createGroupOrder(
      user: user,
      vendorId: cart.vendorId ?? '',
      vendorName: cart.vendorName ?? '',
      cartItems: cart.items,
    );

    if (groupId != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GroupCartScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = context.watch<GroupOrderProvider>();

    // Already in a group order — show compact joined state
    if (group.isInGroupOrder) {
      return _JoinedBanner(
        onOpen: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GroupCartScreen()),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _expand,
      builder: (context, _) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // ── Toggle row ──────────────────────────────────
              InkWell(
                onTap: () {
                  if (_ctrl.value == 0) {
                    _ctrl.forward();
                  } else {
                    _ctrl.reverse();
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.group_add_outlined,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order with friends',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Split one delivery, everyone picks their food',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(_expand),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Expanded invite options ─────────────────────
              SizeTransition(
                sizeFactor: _expand,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: Column(
                    children: [
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Text(
                        'Your cart becomes the group order. Friends join and add their own items — one delivery for everyone.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _startGroupOrder(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Start group order',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Already in group — compact badge ──────────────────────────
class _JoinedBanner extends StatelessWidget {
  final VoidCallback onOpen;
  const _JoinedBanner({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final group = context.watch<GroupOrderProvider>();
    final memberCount = group.groupOrder?.members.length ?? 1;

    return GestureDetector(
      onTap: onOpen,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.group, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Group order • $memberCount ${memberCount == 1 ? 'person' : 'people'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            const Text(
              'View →',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
