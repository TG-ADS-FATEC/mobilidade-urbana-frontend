

import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

class TEditProfileIcon extends StatelessWidget {
  const TEditProfileIcon ({
    super.key,
    required this.isDark, this.iconColor, required this.onPressed,
  });
  final Color? iconColor;
  final VoidCallback onPressed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(onPressed: onPressed, icon: Icon(Icons.manage_accounts_rounded, color: isDark ? TColors.white : TColors.black)),
      ],
    );
  }
}