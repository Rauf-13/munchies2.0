import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/user_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _orderUpdates = true;
  bool _promoAlerts = false;
  bool _soundEnabled = true;
  bool _locationAccess = true;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'Nigerian Naira (₦)';

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final languages = ['English', 'Hausa', 'Yoruba', 'Igbo'];
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Language',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              ...languages.map(
                (lang) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(lang),
                  trailing: _selectedLanguage == lang
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.primary,
                        )
                      : null,
                  onTap: () {
                    setState(() => _selectedLanguage = lang);
                    Navigator.pop(ctx);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Account',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.error),
        ),
        content: const Text(
          'This will permanently delete your account and all your data. This cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Account deletion coming soon'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

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
          'Settings',
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
          // Account mini card
          if (user != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
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
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withOpacity(0.15),
                    child: Text(
                      user.firstName[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Notifications
          _SectionHeader(title: 'Notifications'),
          _SettingsCard(
            children: [
              _ToggleTile(
                icon: Icons.notifications_rounded,
                label: 'Push Notifications',
                subtitle: 'Receive app notifications',
                value: _pushNotifications,
                onChanged: (v) => setState(() => _pushNotifications = v),
              ),
              _Divider(),
              _ToggleTile(
                icon: Icons.local_shipping_rounded,
                label: 'Order Updates',
                subtitle: 'Track your order in real-time',
                value: _orderUpdates,
                onChanged: (v) => setState(() => _orderUpdates = v),
              ),
              _Divider(),
              _ToggleTile(
                icon: Icons.local_offer_rounded,
                label: 'Promos & Offers',
                subtitle: 'Get deals from vendors',
                value: _promoAlerts,
                onChanged: (v) => setState(() => _promoAlerts = v),
              ),
              _Divider(),
              _ToggleTile(
                icon: Icons.volume_up_rounded,
                label: 'Sound',
                subtitle: 'Notification sounds',
                value: _soundEnabled,
                onChanged: (v) => setState(() => _soundEnabled = v),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Privacy & Location
          _SectionHeader(title: 'Privacy & Permissions'),
          _SettingsCard(
            children: [
              _ToggleTile(
                icon: Icons.location_on_rounded,
                label: 'Location Access',
                subtitle: 'Used to find nearby vendors',
                value: _locationAccess,
                onChanged: (v) => setState(() => _locationAccess = v),
              ),
              _Divider(),
              _NavTile(
                icon: Icons.privacy_tip_rounded,
                label: 'Privacy Policy',
                onTap: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(_comingSoon('Privacy policy coming soon')),
              ),
              _Divider(),
              _NavTile(
                icon: Icons.description_rounded,
                label: 'Terms of Service',
                onTap: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(_comingSoon('Terms coming soon')),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Preferences
          _SectionHeader(title: 'Preferences'),
          _SettingsCard(
            children: [
              _NavTile(
                icon: Icons.language_rounded,
                label: 'Language',
                trailing: Text(
                  _selectedLanguage,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: _showLanguagePicker,
              ),
              _Divider(),
              _NavTile(
                icon: Icons.attach_money_rounded,
                label: 'Currency',
                trailing: Text(
                  _selectedCurrency,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 20),

          // App info
          _SectionHeader(title: 'About'),
          _SettingsCard(
            children: [
              _NavTile(
                icon: Icons.info_outline_rounded,
                label: 'App Version',
                trailing: const Text(
                  'v1.0.0 (Beta)',
                  style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
                ),
                onTap: () {},
              ),
              _Divider(),
              _NavTile(
                icon: Icons.star_outline_rounded,
                label: 'Rate Munchies',
                onTap: () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(_comingSoon('App store rating coming soon')),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Danger zone
          _SectionHeader(title: 'Account'),
          _SettingsCard(
            children: [
              _NavTile(
                icon: Icons.logout_rounded,
                label: 'Log Out',
                iconColor: AppColors.error,
                labelColor: AppColors.error,
                onTap: () {
                  context.read<UserProvider>().logout();
                  Navigator.pop(context);
                },
              ),
              _Divider(),
              _NavTile(
                icon: Icons.delete_forever_rounded,
                label: 'Delete Account',
                iconColor: AppColors.error,
                labelColor: AppColors.error,
                onTap: _showDeleteAccountDialog,
              ),
            ],
          ),

          const SizedBox(height: 32),
          Center(
            child: Text(
              'Munchies · Made for students in Kano',
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  SnackBar _comingSoon(String msg) => SnackBar(
    content: Text(msg),
    backgroundColor: AppColors.primary,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.all(16),
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(children: children),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: labelColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 64,
      endIndent: 16,
      color: AppColors.border,
    );
  }
}
