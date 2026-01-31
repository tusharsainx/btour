import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/user_model.dart';

class PersonalInfoScreen extends StatelessWidget {
  final UserModel user;

  const PersonalInfoScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        title: const Text('Personal Information'),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _InfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: user.email,
            trailing: user.emailVerified
                ? const Icon(Icons.verified, color: AppColors.success, size: 20)
                : const Icon(
                    Icons.info_outline,
                    color: AppColors.warning,
                    size: 20,
                  ),
          ),
          const Divider(height: 32),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: user.phoneNumber ?? 'Not added',
            trailing: user.phoneVerified && user.phoneNumber != null
                ? const Icon(Icons.verified, color: AppColors.success, size: 20)
                : null,
          ),
          const Divider(height: 32),
          _InfoRow(
            icon: Icons.badge_outlined,
            label: 'Account Type',
            value: user.role.toUpperCase(),
          ),
          const Divider(height: 32),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Member Since',
            value: _formatDate(user.createdAt),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

// Helper function to format date
String _formatDate(DateTime date) {
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.year}';
}
