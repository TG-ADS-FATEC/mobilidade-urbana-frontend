import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences.entity.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/controllers/preferences_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class ProfileWalkingOptions extends StatelessWidget {
  const ProfileWalkingOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = Get.find<PreferencesController>();

    return Obx(() {
      final current = controller.preferences.value;
      if (current == null) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: TSizes.spaceBtwSections),
          _WalkingPaceSwitch(
            isDark: isDark,
            value: current.slowPace,
            onChanged: (value) {
              controller.updatePreferences(
                current.copyWith(slowPace: value),
              );
            },
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          _WalkingDurationSection(
            duration: current.maxWalkingTime.toDouble(),
            onTap: () => _showDurationPicker(context, controller, current),
          ),
        ],
      );
    });
  }

  void _showDurationPicker(
      BuildContext context,
      PreferencesController controller,
      PreferencesEntity current,
      ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => _WalkingDurationBottomSheet(
        initialValue: current.maxWalkingTime,
        onConfirm: (value) {
          controller.updatePreferences(
            current.copyWith(maxWalkingTime: value),
          );
        },
      ),
    );
  }
}

class _WalkingPaceSwitch extends StatelessWidget {
  final bool isDark;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _WalkingPaceSwitch({
    required this.isDark,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Ritmo de caminhada lento',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: Colors.white,
          activeTrackColor: TColors.primary,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: isDark ? Colors.black38 : Colors.grey.shade300,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _WalkingDurationSection extends StatelessWidget {
  final double duration;
  final VoidCallback onTap;

  const _WalkingDurationSection({
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duração da caminhada',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Text(
          'Define o máximo de minutos para cada seção de caminhada da sua viagem',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : Colors.black,
                side: BorderSide(color: isDark ? Colors.white : Colors.black),
              ),
              icon: const Icon(Icons.directions_walk_outlined, size: 18),
              label: const Text('Definir duração'),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
              child: Text(
                duration >= 60 ? 'Padrão (sem limite)' : '${duration.toInt()} min',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WalkingDurationBottomSheet extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onConfirm;

  const _WalkingDurationBottomSheet({
    required this.initialValue,
    required this.onConfirm,
  });

  @override
  State<_WalkingDurationBottomSheet> createState() =>
      _WalkingDurationBottomSheetState();
}

class _WalkingDurationBottomSheetState
    extends State<_WalkingDurationBottomSheet> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Duração máxima de caminhada',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            _value >= 60 ? 'Sem limite' : '${_value.toInt()} min',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Slider(
            value: _value,
            min: 5,
            max: 60,
            divisions: 11,
            activeColor: TColors.primary,
            onChanged: (v) => setState(() => _value = v),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onConfirm(_value.toInt());
                Navigator.pop(context);
              },
              child: const Text('Confirmar'),
            ),
          ),
        ],
      ),
    );
  }
}