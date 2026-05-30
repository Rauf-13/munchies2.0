import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

enum TrackingStepStatus { done, active, pending }

class TrackingStep extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final TrackingStepStatus status;
  final bool isLast;

  const TrackingStep({
    super.key,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.status,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = status == TrackingStepStatus.done;
    final isActive = status == TrackingStepStatus.active;
    final isPending = status == TrackingStepStatus.pending;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column: icon + line
        Column(
          children: [
            // Step icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDone
                    ? AppColors.success
                    : isActive
                        ? AppColors.primary
                        : const Color(0xFFF0F0F0),
                shape: BoxShape.circle,
              ),
              child: isDone
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    )
                  : Icon(
                      icon,
                      color: isActive
                          ? Colors.white
                          : const Color(0xFFBBBBBB),
                      size: 20,
                    ),
            ),
            // Connector line
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isDone
                      ? AppColors.success
                      : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),

        const SizedBox(width: 14),

        // Right column: text
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: 8,
              bottom: isLast ? 0 : 28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isPending
                              ? const Color(0xFFBBBBBB)
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (isActive)
                      _PulsingDot(),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isPending
                        ? const Color(0xFFCCCCCC)
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Animated pulsing dot for active step
class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}