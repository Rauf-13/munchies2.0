import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class _FaqItem {
  final String question;
  final String answer;
  bool isExpanded = false;

  _FaqItem({required this.question, required this.answer});
}

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<_FaqItem> _faqs = [
    _FaqItem(
      question: 'How do I place an order?',
      answer:
          'Browse vendors on the home screen, pick a vendor, add items to your cart, and tap "Place Order" at checkout. You can pay with card, OPay, or cash on delivery.',
    ),
    _FaqItem(
      question: 'How long does delivery take?',
      answer:
          'Most campus deliveries take 15–30 minutes depending on your location and the vendor\'s preparation time. You can track your order live after placing it.',
    ),
    _FaqItem(
      question: 'Can I order from multiple vendors?',
      answer:
          'Currently each order can only be from one vendor at a time. Adding items from a new vendor will replace your current cart. Group ordering with separate vendor selections is coming soon.',
    ),
    _FaqItem(
      question: 'What is Chop Budget?',
      answer:
          'Chop Budget is our AI meal planner. Set your daily or weekly budget and it will suggest meals that fit your spending, track what you\'ve spent, and find the best value meals near you.',
    ),
    _FaqItem(
      question: 'How do I cancel an order?',
      answer:
          'You can cancel within 2 minutes of placing your order. After that, the vendor has already started preparing your food. Contact support if you have an issue after that window.',
    ),
    _FaqItem(
      question: 'What payment methods are accepted?',
      answer:
          'We accept debit/credit cards (via Paystack), OPay, GTBank, Access Bank transfers, and cash on delivery. More mobile money options are coming soon.',
    ),
    _FaqItem(
      question: 'How do I become a vendor on Munchies?',
      answer:
          'Select "Vendor" during sign up or role selection. You\'ll get access to a vendor dashboard where you can manage your menu, track orders, and handle payments. Vendor onboarding is currently in beta.',
    ),
    _FaqItem(
      question: 'My order was wrong or missing items, what do I do?',
      answer:
          'Tap "Report a Problem" in your order history or contact support directly via WhatsApp. We\'ll resolve it within 24 hours — refunds or reorders depending on the issue.',
    ),
  ];

  List<_FaqItem> get _filteredFaqs {
    if (_searchQuery.isEmpty) return _faqs;
    return _faqs
        .where(
          (faq) =>
              faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              faq.answer.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'How can we help?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Search FAQs or contact the team directly.',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search FAQs...',
                hintStyle: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear_rounded,
                          color: AppColors.textTertiary,
                          size: 18,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Contact options
          const Text(
            'Contact Us',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ContactCard(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Live Chat',
                  subtitle: 'Avg. reply: 5 min',
                  onTap: () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(_snack('Live chat coming soon')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ContactCard(
                  icon: Icons.message_rounded,
                  label: 'WhatsApp',
                  subtitle: '+234 800 000 0000',
                  iconColor: const Color(0xFF25D366),
                  onTap: () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(_snack('Opening WhatsApp...')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ContactCard(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  subtitle: 'support@munchies.ng',
                  onTap: () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(_snack('Opening email...')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ContactCard(
                  icon: Icons.report_problem_outlined,
                  label: 'Report Issue',
                  subtitle: 'Wrong order, refund',
                  iconColor: AppColors.error,
                  onTap: () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(_snack('Report flow coming soon')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // FAQs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              if (_searchQuery.isNotEmpty)
                Text(
                  '${_filteredFaqs.length} result${_filteredFaqs.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          if (_filteredFaqs.isEmpty)
            _EmptySearchState(query: _searchQuery)
          else
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: _filteredFaqs.asMap().entries.map((entry) {
                  final i = entry.key;
                  final faq = entry.value;
                  final isLast = i == _filteredFaqs.length - 1;

                  return Column(
                    children: [
                      _FaqTile(
                        faq: faq,
                        onToggle: () =>
                            setState(() => faq.isExpanded = !faq.isExpanded),
                      ),
                      if (!isLast)
                        const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: AppColors.border,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: 24),

          // Still need help?
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.primaryOrange.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.headset_mic_rounded,
                  color: AppColors.primaryOrange,
                  size: 22,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Still need help?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Our support team is available 8am–10pm daily.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(_snack('Opening support chat...')),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  SnackBar _snack(String msg) => SnackBar(
    content: Text(msg),
    backgroundColor: AppColors.primaryOrange,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.all(16),
  );
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
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
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primaryOrange).withOpacity(0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primaryOrange,
                size: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final _FaqItem faq;
  final VoidCallback onToggle;

  const _FaqTile({required this.faq, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    faq.question,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  faq.isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textTertiary,
                  size: 22,
                ),
              ],
            ),
            if (faq.isExpanded) ...[
              const SizedBox(height: 10),
              Text(
                faq.answer,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  final String query;
  const _EmptySearchState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: AppColors.textTertiary,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            'No results for "$query"',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try a different keyword or contact support',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
