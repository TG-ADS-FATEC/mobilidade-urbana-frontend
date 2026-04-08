import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/features/onboarding/controllers/onboarding_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';

class OnboardingTransportSelector extends StatelessWidget {
  const OnboardingTransportSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;

    final transports = [
      (
        label: 'Ônibus',
        icon: Icons.directions_bus_outlined,
      ),
      (
        label: 'Trem',
        icon: Icons.train_outlined,
      ),
      (
        label: 'Metrô',
        icon: Icons.subway_outlined,
      ),
    ];

    return Obx(
      () =>
        Column(
          children: transports.map((transport) {
            return SwitchListTile(
              value: controller.isTransportEnabled(transport.label),
              onChanged: (value) {
                controller.toggleTransport(transport.label, value);
              },
              secondary: Icon(transport.icon),
              title: Text(transport.label),
              contentPadding: EdgeInsets.zero,
              activeColor: TColors.white,
              activeTrackColor: TColors.primary,
              inactiveThumbColor: Theme.of(context).colorScheme.outline,
              inactiveTrackColor: Colors.transparent,
            );
          }
        ).toList(),
      ),
    );
  }
}