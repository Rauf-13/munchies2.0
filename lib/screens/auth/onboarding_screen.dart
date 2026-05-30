import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'welcome_screen.dart';
import 'widgets/onboarding_slide.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _goToWelcome();
    }
  }

  void _goToWelcome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, right: 24),
                    child: GestureDetector(
                      onTap: _goToWelcome,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    children: const [_Slide1(), _Slide2(), _Slide3()],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_totalPages, (i) {
                    final isActive = i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primaryOrange
                            : const Color(0xFFCCCCCC),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _currentPage == _totalPages - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SLIDE 1 — unchanged
// ─────────────────────────────────────────────
class _Slide1 extends StatelessWidget {
  const _Slide1();

  @override
  Widget build(BuildContext context) {
    return OnboardingSlide(
      illustration: _Slide1Illustration(),
      title: const Text(
        'Your favorite spots\ndelivered to you, on campus',
        textAlign: TextAlign.center,
      ),
      subtitle:
          'From mama put to shawarma — all your campus eats, even your late-night cravings.',
    );
  }
}

class _Slide1Illustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 280,
          height: 280,
          decoration: const BoxDecoration(
            color: Color(0xFFEEDDD0),
            shape: BoxShape.circle,
          ),
        ),
        ClipOval(
          child: Image.network(
            'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=500',
            width: 260,
            height: 260,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 260,
              height: 260,
              color: AppColors.primaryOrange.withOpacity(0.15),
              child: const Icon(
                Icons.restaurant_rounded,
                size: 60,
                color: AppColors.primaryOrange,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _FoodChip(label: 'Amala'),
                  SizedBox(width: 8),
                  _FoodChip(label: 'Shawarma'),
                  SizedBox(width: 8),
                  _FoodChip(label: 'Pepper Soup'),
                ],
              ),
              const SizedBox(height: 8),
              const _FoodChip(label: 'Suya'),
            ],
          ),
        ),
      ],
    );
  }
}

class _FoodChip extends StatelessWidget {
  final String label;
  const _FoodChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SLIDE 2 — unchanged
// ─────────────────────────────────────────────
class _Slide2 extends StatelessWidget {
  const _Slide2();

  @override
  Widget build(BuildContext context) {
    return OnboardingSlide(
      illustration: _Slide2Illustration(),
      title: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Smart Ordering for\n',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
                height: 1.2,
              ),
            ),
            TextSpan(
              text: 'School Life',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryOrange,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
      subtitle:
          'Set your Chop Budget. Our AI finds the best meals your money can buy — every single day.',
    );
  }
}

class _Slide2Illustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 280,
          height: 280,
          decoration: const BoxDecoration(
            color: Color(0xFFEEDDD0),
            shape: BoxShape.circle,
          ),
        ),
        ClipOval(
          child: Image.network(
            'https://images.unsplash.com/photo-1574484284002-952d92456975?w=500',
            width: 260,
            height: 260,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 260,
              height: 260,
              color: AppColors.primaryOrange.withOpacity(0.15),
              child: const Icon(
                Icons.rice_bowl_rounded,
                size: 60,
                color: AppColors.primaryOrange,
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryOrange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Assistant',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Found Jollof under ₦1500!',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.wallet_rounded,
                        color: AppColors.primaryOrange,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chop Budget',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '₦2,000 remaining today',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: 160,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.45,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
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

// ─────────────────────────────────────────────
// SLIDE 3 — CHANGES:
// 1. Notes card: shorter (tight bottom padding), tilted left
// 2. Group link card: tilted right, overlaps BOL of "Bolu", "u" peeks out
// ─────────────────────────────────────────────
class _Slide3 extends StatelessWidget {
  const _Slide3();

  @override
  Widget build(BuildContext context) {
    return OnboardingSlide(
      illustration: _Slide3Illustration(),
      title: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Delete that\n',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
                height: 1.2,
              ),
            ),
            TextSpan(
              text: 'notes app order',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryOrange,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
      subtitle:
          "We both know it's a mess. Just send your friends a Munchies link instead.",
    );
  }
}

class _Slide3Illustration extends StatelessWidget {
  static const Color _notesYellow = Color(0xFFFFD60A);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Circle background
        Container(
          width: 340,
          height: 340,
          decoration: const BoxDecoration(
            color: Color(0xFFEEDDD0),
            shape: BoxShape.circle,
          ),
        ),

        // Notes card — tilted left, shorter bottom padding so card
        // ends snugly just after Bolu text
        Transform.rotate(
          angle: -0.07,
          child: Container(
            width: 300,
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Folders — iPhone Notes yellow
                Row(
                  children: const [
                    Icon(
                      Icons.chevron_left_rounded,
                      color: _notesYellow,
                      size: 22,
                    ),
                    Text(
                      'Folders',
                      style: TextStyle(
                        fontSize: 17,
                        color: _notesYellow,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Friday food order 🤦',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 8),
                Text(
                  'Samad – jollof & chicken',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textTertiary,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'wait no, fried rice',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.primaryOrange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 8),
                const Text(
                  'Fatima – peppered gizzard extra sauce',
                  style: TextStyle(fontSize: 15, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 8),
                // Bolu — will be partially covered by group card
                const Text(
                  'Bolu – (sign up)',
                  style: TextStyle(fontSize: 15, color: AppColors.textTertiary),
                ),
                // Tight bottom — just enough breathing room
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),

        // Munchies group link card — tilted right, covers "BOL", "u" peeks out
        Positioned(
          bottom: 28,
          left: 10,
          child: Transform.rotate(
            angle: 0.06,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 14,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.link_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Munchies Group Order',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'munchies.app/j/8x9p',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
