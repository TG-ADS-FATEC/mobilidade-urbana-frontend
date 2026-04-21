import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/image_strings.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/shared/widgets/circular_Image.dart';
import 'package:mobilidade_urbana_app/utils/constants/text_sizes.dart';
import 'package:mobilidade_urbana_app/utils/shared/widgets/section_heading.dart';

class NearbyVehicles extends StatelessWidget {
  const NearbyVehicles({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: TSizes.xs),
          child: Column(
            children: [
              TSectionHeading(title: 'Nas proximidades', showActionButton: true),
              SizedBox(height: TSizes.spaceBtwItems),
            ]
          ),
        )

    );
  }
}