import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/section_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _priceDropAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeader(),
                  const SizedBox(height: 28),
                  _buildProfileCard(),
                  const SizedBox(height: 32),
                  const SectionHeader(title: 'Preferences'),
                  const SizedBox(height: 14),
                  _buildPreferencesCard(),
                  const SizedBox(height: 28),
                  const SectionHeader(title: 'Notifications'),
                  const SizedBox(height: 14),
                  _buildNotificationsCard(),
                  const SizedBox(height: 28),
                  const SectionHeader(title: 'Support'),
                  const SizedBox(height: 14),
                  _buildSupportCard(),
                  const SizedBox(height: 28),
                  _buildFooter(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'A I R P I N G',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.5,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Your profile.',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Manage your account and preferences.',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.person_fill,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guest User',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Sign in to manage your account',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            CupertinoIcons.chevron_right,
            size: 17,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard() {
    return _SettingsCard(
      children: [
        _SettingsTile(
          icon: CupertinoIcons.globe,
          title: 'Market',
          subtitle: 'India',
          onTap: () => _showComingSoon('Market settings'),
        ),
        const _SettingsDivider(),
        _SettingsTile(
          icon: Icons.currency_rupee,
          title: 'Currency',
          subtitle: 'Indian Rupee (INR)',
          onTap: () => _showComingSoon('Currency settings'),
        ),
        const _SettingsDivider(),
        _SettingsTile(
          icon: CupertinoIcons.calendar,
          title: 'Default travel dates',
          subtitle: 'Flexible date range',
          onTap: () => _showComingSoon('Travel date preferences'),
        ),
      ],
    );
  }

  Widget _buildNotificationsCard() {
    return _SettingsCard(
      children: [
        _SettingsSwitch(
          icon: CupertinoIcons.bell,
          title: 'Push notifications',
          subtitle: 'Receive alerts on your device',
          value: _pushNotifications,
          onChanged: (value) {
            setState(() => _pushNotifications = value);
          },
        ),
        const _SettingsDivider(),
        _SettingsSwitch(
          icon: CupertinoIcons.envelope,
          title: 'Email notifications',
          subtitle: 'Receive price updates by email',
          value: _emailNotifications,
          onChanged: (value) {
            setState(() => _emailNotifications = value);
          },
        ),
        const _SettingsDivider(),
        _SettingsSwitch(
          icon: CupertinoIcons.arrow_down_right,
          title: 'Price drop alerts',
          subtitle: 'Notify me when fares decrease',
          value: _priceDropAlerts,
          onChanged: (value) {
            setState(() => _priceDropAlerts = value);
          },
        ),
      ],
    );
  }

  Widget _buildSupportCard() {
    return _SettingsCard(
      children: [
        _SettingsTile(
          icon: CupertinoIcons.question_circle,
          title: 'Help center',
          onTap: () => _showComingSoon('Help center'),
        ),
        const _SettingsDivider(),
        _SettingsTile(
          icon: CupertinoIcons.chat_bubble,
          title: 'Contact support',
          onTap: () => _showComingSoon('Contact support'),
        ),
        const _SettingsDivider(),
        _SettingsTile(
          icon: CupertinoIcons.doc_text,
          title: 'Privacy policy',
          onTap: () => _showComingSoon('Privacy policy'),
        ),
        const _SettingsDivider(),
        _SettingsTile(
          icon: CupertinoIcons.info_circle,
          title: 'About AirPing',
          subtitle: 'Version 1.0.0',
          onTap: () => _showComingSoon('About AirPing'),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return const Column(
      children: [
        Text(
          'A I R P I N G',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Find your next flight for less.',
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        SizedBox(height: 12),
        Text(
          'Made for smarter travel.',
          style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be available soon.'),
        behavior: SnackBarBehavior.floating,
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Icon(icon, size: 19, color: AppColors.textSecondary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 15,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({
    required this.icon,
    required this.title,
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
          Icon(icon, size: 19, color: AppColors.textSecondary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: AppColors.border),
    );
  }
}
