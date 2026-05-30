import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'widgets/map_placeholder.dart';
import 'widgets/rider_card.dart';
import 'widgets/tracking_step.dart';

enum OrderStatus { confirmed, preparing, onTheWay, delivered }

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  final String vendorName;
  final double orderTotal;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
    required this.vendorName,
    required this.orderTotal,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  OrderStatus _currentStatus = OrderStatus.confirmed;
  bool _summaryExpanded = false;

  @override
  void initState() {
    super.initState();
    _simulateOrderProgress();
  }

  void _simulateOrderProgress() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() => _currentStatus = OrderStatus.preparing);

    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    setState(() => _currentStatus = OrderStatus.onTheWay);

    await Future.delayed(const Duration(seconds: 8));
    if (!mounted) return;
    setState(() => _currentStatus = OrderStatus.delivered);
  }

  int get _currentStep => _currentStatus.index;

  static const _scaffoldBg = Color(0xFFF5F5F5);

  // ── Status helpers ──────────────────────────────────────────────────────────

  String get _headlineText {
    switch (_currentStatus) {
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Being Prepared';
      case OrderStatus.onTheWay:
        return 'On the Way';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  String get _statusLabel {
    switch (_currentStatus) {
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.onTheWay:
        return 'In Transit';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  Color get _statusColor {
    switch (_currentStatus) {
      case OrderStatus.confirmed:
        return const Color(0xFF3B82F6); // blue
      case OrderStatus.preparing:
        return const Color(0xFFF59E0B); // amber
      case OrderStatus.onTheWay:
        return AppColors.primary; // orange
      case OrderStatus.delivered:
        return AppColors.success; // green
    }
  }

  // ───────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const MapPlaceholder(),
                    const SizedBox(height: 20),
                    _buildStatusCard(),
                    const SizedBox(height: 16),
                    if (_currentStatus == OrderStatus.onTheWay ||
                        _currentStatus == OrderStatus.delivered)
                      const RiderCard(),
                    const SizedBox(height: 16),
                    _buildOrderSummary(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: _scaffoldBg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
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
          ),
          const Expanded(
            child: Text(
              'Order Tracking',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
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
              Icons.receipt_long_outlined,
              size: 22,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final steps = [
      _StepData(
        label: 'Order Confirmed',
        subtitle: 'We\'ve received your order',
        icon: Icons.check_circle_outline_rounded,
      ),
      _StepData(
        label: 'Being Prepared',
        subtitle: 'Vendor is cooking your food',
        icon: Icons.restaurant_outlined,
      ),
      _StepData(
        label: 'On the Way',
        subtitle: 'Rider is heading to you',
        icon: Icons.directions_bike_outlined,
      ),
      _StepData(
        label: 'Delivered',
        subtitle: 'Enjoy your meal!',
        icon: Icons.home_outlined,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Headline + status pill
          Row(
            children: [
              Expanded(
                child: Text(
                  _headlineText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _statusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(
            'Order #${widget.orderId} · ${widget.vendorName}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Steps
          ...List.generate(steps.length, (index) {
            final step = steps[index];
            final status = index < _currentStep
                ? TrackingStepStatus.done
                : index == _currentStep
                ? TrackingStepStatus.active
                : TrackingStepStatus.pending;
            final isLast = index == steps.length - 1;

            return TrackingStep(
              label: step.label,
              subtitle: step.subtitle,
              icon: step.icon,
              status: status,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
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
          GestureDetector(
            onTap: () => setState(() => _summaryExpanded = !_summaryExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '₦${widget.orderTotal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _summaryExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_summaryExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _summaryRow(
                    'Subtotal',
                    '₦${(widget.orderTotal - 1000).toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 8),
                  _summaryRow('Delivery Fee', '₦800'),
                  const SizedBox(height: 8),
                  _summaryRow('Service Fee', '₦200'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Color(0xFFF0F0F0)),
                  ),
                  _summaryRow(
                    'Total',
                    '₦${widget.orderTotal.toStringAsFixed(0)}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final isDelivered = _currentStatus == OrderStatus.delivered;

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
            if (isDelivered) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDelivered
                ? AppColors.primary
                : const Color(0xFFE0E0E0),
            foregroundColor: isDelivered
                ? Colors.white
                : AppColors.textSecondary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            isDelivered ? 'Rate your order' : 'Waiting for delivery...',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _StepData {
  final String label;
  final String subtitle;
  final IconData icon;

  _StepData({required this.label, required this.subtitle, required this.icon});
}
