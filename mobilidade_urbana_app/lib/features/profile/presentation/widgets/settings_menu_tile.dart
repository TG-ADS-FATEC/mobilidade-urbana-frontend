import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

class TSettingsMenuTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Widget? trailing;
  final void Function() onTap;

  const TSettingsMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        color: isDark ? TColors.darkSurface : TColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, size: TSizes.md, color: isDark ? TColors.grey : TColors.darkGrey),
        title: Text(title, style: Theme
            .of(context)
            .textTheme
            .titleSmall),
        subtitle: Text(subtitle, style: Theme
            .of(context)
            .textTheme
            .bodySmall),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}