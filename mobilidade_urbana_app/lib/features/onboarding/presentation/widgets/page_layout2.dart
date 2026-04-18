import 'package:flutter/material.dart';

import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

class OnBoardingPageLayout2 extends StatelessWidget {
  const OnBoardingPageLayout2({
    super.key,
    required this.title,
    required this.description,
    required this.title2,
    required this.description2,
    this.firstInput,
    this.secondInput,
  });

  final String title;
  final String description;
  final String title2;
  final String description2;

  final Widget? firstInput;
  final Widget? secondInput;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: TSizes.xl * 2,
        left: TSizes.defaultSpace,
        right: TSizes.defaultSpace,
        bottom: TSizes.defaultSpace,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: TSizes.xl),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          if (firstInput != null) ...[
            const SizedBox(height: TSizes.spaceBtwSections),
            firstInput!,
          ],

          const SizedBox(height: TSizes.spaceBtwSections),

          Text(
            title2,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          Text(
            description2,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          if (secondInput != null) ...[
            const SizedBox(height: TSizes.spaceBtwSections),
            secondInput!,
          ],
        ],
      ),
    );
  }
}