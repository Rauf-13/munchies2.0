// lib/screens/wellness/wellness_setup_flow.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/wellness_provider.dart';
import 'widgets/restriction_chip.dart';
import 'widgets/condition_checkbox.dart';
import 'widgets/wellness_confirm.dart';

class WellnessSetupFlow extends StatefulWidget {
  const WellnessSetupFlow({super.key});

  @override
  State<WellnessSetupFlow> createState() => _WellnessSetupFlowState();
}

class _WellnessSetupFlowState extends State<WellnessSetupFlow> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 1
  final List<String> _allRestrictions = [
    'No Beef',
    'No Pork',
    'No Dairy',
    'No Gluten',
    'No Nuts',
    'No Spicy',
    'No Red Meat',
    'No Fish',
  ];
  final List<String> _selectedRestrictions = [];
  final TextEditingController _customController = TextEditingController();

  // Step 2
  final List<String> _allConditions = [
    'Diabetes',
    'Hypertension',
    'High Cholesterol',
    'Lactose Intolerance',
    'Ulcer',
    'Prefer Low-Oil Meals',
    'Prefer High-Protein Meals',
  ];
  final List<String> _selectedConditions = [];

  @override
  void dispose() {
    _pageController.dispose();
    _customController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  void _completeSetup() {
    context.read<WellnessProvider>().completeSetup(
      dietaryRestrictions: _selectedRestrictions,
      healthConditions: _selectedConditions,
      customRestriction: _customController.text.trim().isEmpty
          ? null
          : _customController.text.trim(),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [_buildStep1(), _buildStep2(), _buildStep3()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final titles = [
      'Dietary Restrictions',
      'Health Conditions',
      'You\'re all set',
    ];
    final subtitles = [
      'Select everything that applies to you',
      'Optional — helps us flag risky meals',
      'Here\'s what Wellness Mode does',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (_currentStep > 0)
                GestureDetector(
                  onTap: _prevStep,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.arrow_back, size: 18),
                  ),
                )
              else
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.close, size: 18),
                  ),
                ),
              const SizedBox(width: 12),
              // Munchies leaf badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🌿', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 6),
                    Text(
                      'Wellness Mode',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                'Step ${_currentStep + 1} of 3',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Column(
              key: ValueKey(_currentStep),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titles[_currentStep],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitles[_currentStep],
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 2 ? 6 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? AppColors.primary
                    : AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Step 1 — Dietary Restrictions ──
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _allRestrictions.map((r) {
              final selected = _selectedRestrictions.contains(r);
              return RestrictionChip(
                label: r,
                selected: selected,
                onTap: () {
                  setState(() {
                    if (selected) {
                      _selectedRestrictions.remove(r);
                    } else {
                      _selectedRestrictions.add(r);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Custom restriction field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: _customController,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
              decoration: const InputDecoration(
                hintText: 'Anything else? (optional)',
                hintStyle: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          if (_selectedRestrictions.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: TextButton(
                  onPressed: _nextStep,
                  child: const Text(
                    'Skip — I have no restrictions',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Step 2 — Health Conditions ──
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._allConditions.map((c) {
            final checked = _selectedConditions.contains(c);
            return ConditionCheckbox(
              label: c,
              checked: checked,
              onTap: () {
                setState(() {
                  if (checked) {
                    _selectedConditions.remove(c);
                  } else {
                    _selectedConditions.add(c);
                  }
                });
              },
            );
          }),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Center(
              child: TextButton(
                onPressed: _nextStep,
                child: const Text(
                  'Skip — no conditions to add',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 3 — Confirm ──
  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: WellnessConfirm(
        dietaryRestrictions: _selectedRestrictions,
        healthConditions: _selectedConditions,
        onConfirm: _completeSetup,
      ),
    );
  }
}
