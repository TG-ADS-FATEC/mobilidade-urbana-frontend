import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/device/device_utility.dart';

class TSearchContainer extends StatelessWidget {
  const TSearchContainer({
    super.key,
    required this.isDark, this.searchIcon = Icons.search, this.showBackground = true, this.showBorder = false, required this.placeholder,
  });

  final String placeholder;
  final IconData? searchIcon;
  final bool showBackground, showBorder;

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: TSizes.xs),
      child: Container(
        width: TDeviceUtils.getScreenWidth(context),
        height: TSizes.buttonHeight * 1.25,
        padding: const EdgeInsets.all(TSizes.sm),
        decoration: BoxDecoration(
          color: showBackground
              ? isDark ? TColors.darkSurface : TColors.surface
              : Colors.transparent,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          border: showBorder ? Border.all(color: isDark ? TColors.darkSurface : TColors.surface) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(searchIcon, color: isDark ? TColors.white : TColors.darkGrey, size: TSizes.iconMd),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(placeholder, style: Theme.of(context).textTheme.bodySmall)
          ],
        ),
      ),
    );
  }
}