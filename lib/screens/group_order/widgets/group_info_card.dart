import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/group_order_model.dart';

class GroupInfoCard extends StatefulWidget {
  final GroupOrderModel order;
  final String currentUserId;

  const GroupInfoCard({
    super.key,
    required this.order,
    required this.currentUserId,
  });

  @override
  State<GroupInfoCard> createState() => _GroupInfoCardState();
}

class _GroupInfoCardState extends State<GroupInfoCard> {
  late Duration _remaining;
  late bool _hasTimer;

  @override
  void initState() {
    super.initState();
    _hasTimer = widget.order.expiresAt != null;
    _updateRemaining();
    if (_hasTimer) _startTick();
  }

  void _updateRemaining() {
    if (!_hasTimer) return;
    final now = DateTime.now();
    _remaining = widget.order.expiresAt!.difference(now);
    if (_remaining.isNegative) _remaining = Duration.zero;
  }

  void _startTick() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(_updateRemaining);
      return _remaining.inSeconds > 0;
    });
  }

  String get _timerLabel {
    final m = _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isHost =
        widget.order.hostId == widget.currentUserId;
    final memberCount = widget.order.members.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          // Left: group size
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ordering with $memberCount ${memberCount == 1 ? 'person' : 'people'}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isHost
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isHost ? "You're the host" : 'You joined',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isHost
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),

                    // Locked badge
                    if (widget.order.isLocked) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_outline_rounded,
                                size: 10, color: AppColors.success),
                            const SizedBox(width: 3),
                            Text(
                              'Order locked',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Right: countdown timer
          if (_hasTimer && _remaining.inSeconds > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _timerLabel,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _remaining.inMinutes < 2
                        ? AppColors.error
                        : AppColors.textPrimary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  'closes in',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}