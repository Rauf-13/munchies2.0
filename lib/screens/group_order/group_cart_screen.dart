import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';

import '../../providers/group_order_provider.dart';
import '../../providers/user_provider.dart';

import '../../screens/checkout/checkout_screen.dart';
import 'widgets/group_info_card.dart';
import 'widgets/member_row.dart';
import 'widgets/member_items_section.dart';
import 'widgets/live_activity_toast.dart';
import 'widgets/group_total_bar.dart';

class GroupCartScreen extends StatelessWidget {
  const GroupCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final group = context.watch<GroupOrderProvider>();
    final user = context.watch<UserProvider>().user!;
    final order = group.groupOrder;

    if (order == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final amHost = group.isHost(user.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── App bar ──────────────────────────────────────
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Column(
                  children: [
                    const Text(
                      'Group Order',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      order.vendorName,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
                actions: [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_horiz_rounded),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) async {
                      if (value == 'copy') {
                        await Clipboard.setData(
                          ClipboardData(text: order.shareLink),
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Link copied!')),
                          );
                        }
                      } else if (value == 'lock' && amHost) {
                        group.lockOrder();
                      } else if (value == 'leave') {
                        _confirmLeave(context, group, user.id);
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'copy',
                        child: Text('Copy invite link'),
                      ),
                      if (amHost && order.isActive)
                        const PopupMenuItem(
                          value: 'lock',
                          child: Text('Lock order'),
                        ),
                      PopupMenuItem(
                        value: 'leave',
                        child: Text(
                          amHost ? 'Cancel group order' : 'Leave group',
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Group info card ───────────────────────
                    GroupInfoCard(order: order, currentUserId: user.id),
                    const SizedBox(height: 12),

                    // ── Member avatars + invite ───────────────
                    MemberRow(order: order, currentUserId: user.id),
                    const SizedBox(height: 20),

                    // ── Items grouped by member ───────────────
                    ...order.members.map((member) {
                      final memberItems = order.itemsForUser(member.userId);
                      return MemberItemsSection(
                        member: member,
                        items: memberItems,
                        isCurrentUser: member.userId == user.id,
                        isLocked: order.isLocked,
                        onRemove: (item) => group.removeItem(item),
                      );
                    }),

                    // ── Empty state hint ──────────────────────
                    if (order.items.isEmpty) _EmptyGroupState(isHost: amHost),
                  ]),
                ),
              ),
            ],
          ),

          // ── Live activity toast ───────────────────────────────
          LiveActivityToast(message: group.lastActivityMessage),

          // ── Sticky total bar ──────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GroupTotalBar(
              order: order,
              isHost: amHost,
              onCheckout: () => _checkout(context, group),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkout(BuildContext context, GroupOrderProvider group) async {
    // Lock the order, then go to checkout
    await group.lockOrder();
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CheckoutScreen()),
      );
    }
  }

  void _confirmLeave(
    BuildContext context,
    GroupOrderProvider group,
    String userId,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Leave group?',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text('Your items will be removed from the group order.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              group.leaveGroup(userId);
              Navigator.pop(context);
            },
            child: const Text(
              'Leave',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyGroupState extends StatelessWidget {
  final bool isHost;
  const _EmptyGroupState({required this.isHost});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(24),
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
          Icon(
            Icons.restaurant_menu_outlined,
            size: 40,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 12),
          Text(
            isHost
                ? 'Share the link so friends can join and add their items'
                : 'Go back to the menu and add your items',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
