import 'package:flutter/material.dart';
import 'package:ngieuapp/app/theme/app_tokens.dart';

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.subtitle,
    super.key,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = iconColor ?? theme.colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: AppRadius.xlBr,
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.08),
              borderRadius: AppRadius.lgBr,
            ),
            child: Icon(icon, color: accent, size: 22),
          ),
          title: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(color: textColor),
          ),
          subtitle: subtitle == null
              ? null
              : Text(subtitle!, maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: textColor ?? theme.colorScheme.onSurfaceVariant,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
