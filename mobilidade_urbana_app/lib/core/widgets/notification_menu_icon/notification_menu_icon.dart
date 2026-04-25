

import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

class TNotificationCounterIcon extends StatelessWidget {
  const TNotificationCounterIcon({
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
        IconButton(onPressed: onPressed, icon: Icon(Icons.notifications, color: isDark ? TColors.white : TColors.black)),
        Positioned(
          right: 8,
          child: Container(
            width: TSizes.sm,
            height: TSizes.sm,
            decoration: BoxDecoration(
              color: TColors.soothingLime,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text('2', style: Theme.of(context).textTheme.labelMedium!.apply(color: TColors.black, fontSizeFactor: 0.8)),
            ),
          ),
        )
      ],
    );
  }
}