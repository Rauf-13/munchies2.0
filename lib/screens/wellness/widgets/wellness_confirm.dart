// lib/screens/wellness/widgets/wellness_confirm.dart

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WellnessConfirm extends StatelessWidget {
  final List<String> dietaryRestrictions;
  final List<String> healthConditions;
  final VoidCallback onConfirm;

  const WellnessConfirm({
    super.key,
    required this.dietaryRestrictions,
    required this.healthConditions,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // What changes section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0x08000000),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What changes for you',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              _WhatChangesRow(
                icon: Icons.block,
                iconColor: const Color(0xFFE24B4A),
                text: 'Conflicting menu items will be flagged with a small warning',
              ),
              const SizedBox(height: 12),
              _WhatChangesRow(
                icon: Icons.savings_outlined,
                iconColor: AppColors.primary,
                text: 'Chop Budget suggestions will filter to wellness-safe meals',
              ),
              const SizedBox(height: 12),
              _WhatChangesRow(
                icon: Icons.visibility_off_outlined,
                iconColor: const Color(0xFF666666),
                text: 'No pop-ups or constant reminders — it stays quiet',
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Privacy notice
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lock_outline, size: 18, color: Color(0xFF10B981)),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Vendors don\'t see your health info. This is private to you only.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Summary of selections (if any)
        if (dietaryRestrictions.isNotEmpty || healthConditions.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your preferences',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                if (dietaryRestrictions.isNotEmpty)
                  Text(
                    dietaryRestrictions.join(' · '),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),
                if (healthConditions.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    healthConditions.join(' · '),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // CTA button
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "Got it, let's eat",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WhatChangesRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _WhatChangesRow({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF444444),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}