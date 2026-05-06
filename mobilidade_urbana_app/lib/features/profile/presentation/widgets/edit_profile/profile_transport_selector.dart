import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences.entity.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/controllers/preferences_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';

class ProfileTransportSelector extends ConsumerWidget {
  const ProfileTransportSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(preferencesControllerProvider);
    final notifier = ref.read(preferencesControllerProvider.notifier);

    final current = state.preferences;
    if (current == null) return const SizedBox.shrink();

    final transports = [
      (label: 'Ônibus', icon: Icons.directions_bus_outlined, type: TransportType.bus),
      (label: 'Trem', icon: Icons.train_outlined, type: TransportType.train),
      (label: 'Metrô', icon: Icons.subway_outlined, type: TransportType.subway),
    ];

    return Column(
      children: transports.map((transport) {
        final isEnabled = current.transportTypes.contains(transport.type);

        return SwitchListTile(
          value: isEnabled,
          onChanged: (value) {
            final updated = List<TransportType>.from(current.transportTypes);
            if (value) {
              updated.add(transport.type);
            } else {
              updated.remove(transport.type);
            }
            notifier.updatePreferences(
              current.copyWith(transportTypes: updated),
            );
          },
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
