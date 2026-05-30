import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class OnboardingSlide extends StatelessWidget {
  final Widget illustration;
  final Widget title;
  final String subtitle;
  /// Fraction of screen height for the illustration region (taller helps slide 3 overlap).
  final double illustrationHeightFraction;
  final Color? subtitleColor;
  /// Vertical gap between the illustration block and the title (slide 3 uses a smaller value).
  final double gapAfterIllustration;
  /// Vertical gap between title and subtitle.
  final double gapAfterTitle;

  const OnboardingSlide({
    super.key,
    required this.illustration,
    required this.title,
    required this.subtitle,
    this.illustrationHeightFraction = 0.46,
    this.subtitleColor,
    this.gapAfterIllustration = 24,
    this.gapAfterTitle = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Illustration area — fixed height
        SizedBox(
          height:
              MediaQuery.of(context).size.height * illustrationHeightFraction,
          width: double.infinity,
          child: illustration,
        ),

        SizedBox(height: gapAfterIllustration),

        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.navy,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            child: title,
          ),
        ),

        SizedBox(height: gapAfterTitle),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: subtitleColor ?? AppColors.textSecondary,
              height: 1.55,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}