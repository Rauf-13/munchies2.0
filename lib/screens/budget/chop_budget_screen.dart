// lib/screens/budget/chop_budget_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/dummy_menu_items.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wellness_provider.dart';
import '../../models/menu_item.dart';

class ChopBudgetScreen extends StatefulWidget {
  const ChopBudgetScreen({Key? key}) : super(key: key);

  @override
  State<ChopBudgetScreen> createState() => _ChopBudgetScreenState();
}

class _ChopBudgetScreenState extends State<ChopBudgetScreen> {
  double _selectedBudget = 3500;
  bool _showSuggestions = false;
  bool _showCustomInput = false;
  final TextEditingController _customController = TextEditingController();

  final List<Map<String, dynamic>> _presets = [
    {'label': 'Quick bite', 'amount': 1500.0},
    {'label': 'Balanced meal', 'amount': 2500.0},
    {'label': 'Most popular', 'amount': 3500.0},
    {'label': 'Treat yourself', 'amount': 5000.0},
  ];

  List<MenuItem> _suggestedMeals = [];

  void _findMeals() {
    final wellness = context.read<WellnessProvider>();
    List<MenuItem> pool = wellness.isEnabled
        ? dummyMenuItems
              .where((m) => !wellness.itemConflicts([m.name, ...m.tags]))
              .toList()
        : List.from(dummyMenuItems);

    final results = pool.where((m) => m.price <= _selectedBudget).toList();
    results.sort((a, b) => b.price.compareTo(a.price));

    setState(() {
      _suggestedMeals = results.take(5).toList();
      _showSuggestions = true;
    });
  }

  String _getBudgetBadgeLabel(double price) {
    final diff = _selectedBudget - price;
    if (diff == 0) return 'Exact Budget';
    if (diff <= 300) return 'Almost Budget';
    return 'Under Budget';
  }

  Color _getBudgetBadgeColor(double price) {
    final diff = _selectedBudget - price;
    if (diff == 0) return const Color(0xFFE3F2FD);
    return const Color(0xFFE8F5E9);
  }

  Color _getBudgetBadgeTextColor(double price) {
    final diff = _selectedBudget - price;
    if (diff == 0) return const Color(0xFF1565C0);
    return const Color(0xFF2E7D32);
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chop Budget',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Budget picker card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Pick a budget range',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF888888),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Big amount display
                    Text(
                      '₦${_selectedBudget.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -1,
                      ),
                    ),

                    const SizedBox(height: 4),
                    const Text(
                      'Choose a quick amount instead of dragging a slider',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
                    ),

                    const SizedBox(height: 20),

                    // 2x2 preset grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                      children: _presets.map((preset) {
                        final isSelected = _selectedBudget == preset['amount'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedBudget = preset['amount'];
                              _showCustomInput = false;
                              _showSuggestions = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isSelected)
                                  Text(
                                    preset['label'],
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  )
                                else
                                  Text(
                                    preset['label'],
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF888888),
                                    ),
                                  ),
                                const SizedBox(height: 2),
                                Text(
                                  '₦${(preset['amount'] as double).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected
                                        ? AppColors.primary
                                        : const Color(0xFF1A1A1A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 12),

                    // Custom budget row
                    GestureDetector(
                      onTap: () {
                        setState(() => _showCustomInput = !_showCustomInput);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 18,
                                color: Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Custom budget',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  Text(
                                    'Set any amount that fits you',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF999999),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Custom input field
                    if (_showCustomInput) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              '₦',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _customController,
                                keyboardType: TextInputType.number,
                                autofocus: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter amount',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF999999),
                                  ),
                                ),
                                onSubmitted: (val) {
                                  final parsed = double.tryParse(val);
                                  if (parsed != null && parsed > 0) {
                                    setState(() {
                                      _selectedBudget = parsed;
                                      _showCustomInput = false;
                                      _showSuggestions = false;
                                    });
                                  }
                                },
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                final parsed = double.tryParse(
                                  _customController.text,
                                );
                                if (parsed != null && parsed > 0) {
                                  setState(() {
                                    _selectedBudget = parsed;
                                    _showCustomInput = false;
                                    _showSuggestions = false;
                                  });
                                }
                              },
                              child: const Text('Set'),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Find Meals button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _findMeals,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.search, size: 22),
                        label: const Text(
                          'Find Meals',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // AI Suggestions section
              if (_showSuggestions) ...[
                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AI Suggestions',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    if (context.watch<WellnessProvider>().isEnabled)
                      Row(
                        children: const [
                          Text('🌿', style: TextStyle(fontSize: 12)),
                          SizedBox(width: 4),
                          Text(
                            'Wellness filtered',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF059669),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                if (_suggestedMeals.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'No meals found within this budget.\nTry increasing your budget amount.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF888888),
                          height: 1.5,
                        ),
                      ),
                    ),
                  )
                else
                  ..._suggestedMeals.map((meal) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: meal.imageUrl.isNotEmpty
                                ? Image.network(
                                    meal.imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _placeholder(),
                                  )
                                : _placeholder(),
                          ),

                          const SizedBox(width: 14),

                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meal.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.storefront_outlined,
                                      size: 13,
                                      color: Color(0xFF999999),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _getVendorName(meal.vendorId),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF999999),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '₦${meal.price.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getBudgetBadgeColor(meal.price),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _getBudgetBadgeLabel(meal.price),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: _getBudgetBadgeTextColor(
                                            meal.price,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                // Add to cart buttons
                if (_suggestedMeals.isNotEmpty)
                  ..._suggestedMeals.map((meal) => const SizedBox.shrink()),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getVendorName(String vendorId) {
    const vendorNames = {
      '1': "Iya Basira's Kitchen",
      '2': 'Campus Bite Burgers',
      '3': 'Mama Put Delicacies',
      '4': 'Sharwarma Palace',
      '5': "Zainab's Swallow Spot",
    };
    return vendorNames[vendorId] ?? 'Local Vendor';
  }

  Widget _placeholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 32))),
    );
  }
}
