import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences.entity.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';

class OnboardingTransportSelector extends ConsumerWidget {
  const OnboardingTransportSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);

    final transports = [
      (label: 'Ônibus', icon: Icons.directions_bus_outlined, value: TransportType.bus),
      (label: 'Trem', icon: Icons.train_outlined, value: TransportType.train),
      (label: 'Metrô', icon: Icons.subway_outlined, value: TransportType.subway),
    ];

    return Column(
      children: transports.map((transport) {
        return SwitchListTile(
          value: state.selectedTransports.contains(transport.value),
          onChanged: (_) => notifier.toggleTransport(transport.value),
          secondary: Icon(transport.icon),
          title: Text(transport.label),
          contentPadding: EdgeInsets.zero,
          activeColor: TColors.white,
          activeTrackColor: TColors.primary,
          inactiveThumbColor: Theme.of(context).colorScheme.outline,
          inactiveTrackColor: Colors.transparent,
        );
      }).toList(),
    );
  }
}
