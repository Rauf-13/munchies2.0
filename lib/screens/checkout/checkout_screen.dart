// lib/screens/checkout/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/user_provider.dart';
import '../cart/cart_format.dart';
import '../cart/widgets/cart_summary.dart';
import 'widgets/delivery_address_card.dart';
import 'widgets/payment_method_card.dart';
import '../order_tracking/order_tracking_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'card';
  bool _isPlacingOrder = false;

  // ── Replace with your real pk_test_ key before demo ──
  static const String _paystackPublicKey = 'pk_test_REPLACE_ME';

  final _plugin = PaystackPlugin();

  static const _scaffoldBg = Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    _plugin.initialize(publicKey: _paystackPublicKey);
  }

  String _generateReference() {
    return 'NOM${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _placeOrder(CartProvider cart) async {
    if (_selectedPayment == 'card' || _selectedPayment == 'transfer') {
      await _initiatePaystackPayment(cart);
    } else {
      // Cash on delivery — skip payment gateway
      await _completeOrder(cart);
    }
  }

  Future<void> _initiatePaystackPayment(CartProvider cart) async {
    final user = context.read<UserProvider>().user;
    final email = user?.email ?? 'customer@munchies.app';
    final amountInKobo = (cart.total * 100).toInt();
    final reference = _generateReference();

    Charge charge = Charge()
      ..amount = amountInKobo
      ..reference = reference
      ..email = email
      ..currency = 'NGN'
      ..putMetaData('vendor', cart.vendorName ?? 'Vendor')
      ..putMetaData('app', 'Munchies');

    setState(() => _isPlacingOrder = true);

    try {
      CheckoutResponse response = await _plugin.checkout(
        context,
        method: _selectedPayment == 'transfer'
            ? CheckoutMethod.bank
            : CheckoutMethod.card,
        charge: charge,
        fullscreen: false,
        logo: const Text('🍽️', style: TextStyle(fontSize: 28)),
      );

      if (!mounted) return;

      if (response.status == true) {
        await _completeOrder(cart);
      } else {
        setState(() => _isPlacingOrder = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Payment was not completed.'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isPlacingOrder = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment failed. Please try again.'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _completeOrder(CartProvider cart) async {
    final orderId =
        'NOM${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final vendorName = cart.vendorName ?? 'Vendor';
    final orderTotal = cart.total;

    cart.clear();
    setState(() => _isPlacingOrder = false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderTrackingScreen(
          orderId: orderId,
          vendorName: vendorName,
          orderTotal: orderTotal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final user = context.watch<UserProvider>().user;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    _sectionLabel('Delivery Address'),
                    const SizedBox(height: 10),
                    DeliveryAddressCard(
                      name: user?.fullName ?? 'Your location',
                      address: 'Main Campus Hostel, Kano',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Address selection coming soon!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    _sectionLabel('Order Summary'),
                    const SizedBox(height: 10),
                    _buildOrderItems(cart),

                    const SizedBox(height: 24),

                    _sectionLabel('Payment Method'),
                    const SizedBox(height: 10),
                    PaymentMethodCard(
                      selected: _selectedPayment,
                      onChanged: (value) =>
                          setState(() => _selectedPayment = value),
                    ),

                    const SizedBox(height: 24),

                    _sectionLabel('Price Breakdown'),
                    const SizedBox(height: 10),
                    const CartSummary(),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildPlaceOrderBar(cart),
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
              'Checkout',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildOrderItems(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          if (cart.vendorName != null) ...[
            Row(
              children: [
                const Icon(
                  Icons.storefront_outlined,
                  size: 16,
                  color: Color(0xFF666666),
                ),
                const SizedBox(width: 8),
                Text(
                  cart.vendorName!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const Divider(height: 20, color: Color(0xFFF0F0F0)),
          ],
          ...cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.menuItem.imageUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text('🍽️', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.menuItem.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'x${item.quantity}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatNaira(item.totalPrice),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderBar(CartProvider cart) {
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
          onPressed: _isPlacingOrder ? null : () => _placeOrder(cart),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isPlacingOrder
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedPayment == 'cash' ? 'Place Order' : 'Pay Now',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      formatNaira(cart.total),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
