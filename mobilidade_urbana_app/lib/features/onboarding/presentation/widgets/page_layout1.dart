import 'package:flutter/material.dart';

import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

class OnBoardingPageLayout1 extends StatelessWidget {
  const OnBoardingPageLayout1({
    super.key,
    required this.title,
    required this.description,
    this.child,
  });

  final String title, description;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: TSizes.xl * 2,
        left: TSizes.defaultSpace,
        right: TSizes.defaultSpace,
        bottom: TSizes.defaultSpace,
      ),
      child: Column(
        children: [
          const SizedBox(height: TSizes.xl),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
          if (child != null) ...[
            const SizedBox(height: TSizes.spaceBtwSections),
            child!,
          ],
        ],
      ),
    );
  }
}
