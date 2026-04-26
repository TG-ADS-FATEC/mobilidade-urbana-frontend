import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences.entity.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/controllers/preferences_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';

class ProfileTransportSelector extends StatelessWidget {
  const ProfileTransportSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PreferencesController>();

    final transports = [
      (label: 'Ônibus', icon: Icons.directions_bus_outlined, type: TransportType.bus),
      (label: 'Metrô', icon: Icons.subway_outlined, type: TransportType.subway),
      (label: 'Caminhada', icon: Icons.directions_walk_outlined, type: TransportType.walking),
      (label: 'Bicicleta', icon: Icons.directions_bike_outlined, type: TransportType.cycling),
    ];

    return Obx(() {
      final current = controller.preferences.value;
      if (current == null) return const SizedBox.shrink();

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
              controller.updatePreferences(
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
    });
  }
}

