import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/core/widgets/section_heading.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';


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
              TSectionHeading(title: 'Nas proximidades', showActionButton: true, buttonTitle: "Ver todos"),
              SizedBox(height: TSizes.spaceBtwItems),
            ]
          ),
        )

    );
  }
}