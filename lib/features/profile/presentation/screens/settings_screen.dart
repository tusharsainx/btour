import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btour/core/theme/app_colors.dart';
import 'package:btour/core/theme/app_typography.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Appearance',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: _getThemeModeText(themeMode),
            onTap: () => _showThemeDialog(context, ref),
          ),
          const SizedBox(height: 24),
          Text(
            'Notifications',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            trailing: Switch.adaptive(
              value: true,
              onChanged: (value) {},
              activeTrackColor: AppColors.primary,
            ),
          ),
          _SettingsTile(
            icon: Icons.email_outlined,
            title: 'Email Notifications',
            trailing: Switch.adaptive(
              value: false,
              onChanged: (value) {},
              activeTrackColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'About',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: '1.0.0',
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) => AlertDialog(
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: const Text('Light'),
                trailing: ref.watch(themeModeProvider) == ThemeMode.light
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  ref.read(themeModeProvider.notifier).state = ThemeMode.light;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark'),
                trailing: ref.watch(themeModeProvider) == ThemeMode.dark
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_suggest),
                title: const Text('System'),
                trailing: ref.watch(themeModeProvider) == ThemeMode.system
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  ref.read(themeModeProvider.notifier).state = ThemeMode.system;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTypography.bodyLarge),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              )
            : null,
        trailing:
            trailing ??
            (onTap != null
                ? const Icon(Icons.chevron_right, color: AppColors.textMuted)
                : null),
      ),
    );
  }
}
