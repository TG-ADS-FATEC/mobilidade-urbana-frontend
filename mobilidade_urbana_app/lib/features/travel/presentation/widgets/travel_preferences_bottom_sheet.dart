import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences_entity.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/controllers/preferences_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

// ── Provider de preferências temporárias da viagem ───────────────────────────

class TravelPreferences {
  final RoutePreference routePreference;
  final bool slowPace;
  final int maxWalkingTime;

  const TravelPreferences({
    this.routePreference = RoutePreference.fastest,
    this.slowPace = false,
    this.maxWalkingTime = 10,
  });

  TravelPreferences copyWith({
    RoutePreference? routePreference,
    bool? slowPace,
    int? maxWalkingTime,
  }) =>
      TravelPreferences(
        routePreference: routePreference ?? this.routePreference,
        slowPace: slowPace ?? this.slowPace,
        maxWalkingTime: maxWalkingTime ?? this.maxWalkingTime,
      );
}

final travelPreferencesProvider =
    StateProvider<TravelPreferences>((ref) => const TravelPreferences());

// ── Bottom sheet ──────────────────────────────────────────────────────────────

void showTravelPreferencesSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _TravelPreferencesSheet(),
  );
}

class _TravelPreferencesSheet extends ConsumerStatefulWidget {
  const _TravelPreferencesSheet();

  @override
  ConsumerState<_TravelPreferencesSheet> createState() =>
      _TravelPreferencesSheetState();
}

class _TravelPreferencesSheetState
    extends ConsumerState<_TravelPreferencesSheet> {
  late TravelPreferences _local;

  @override
  void initState() {
    super.initState();
    // Inicializa com as preferências salvas do perfil (se disponíveis)
    final saved = ref.read(preferencesControllerProvider).preferences;
    if (saved != null) {
      _local = TravelPreferences(
        routePreference: saved.routePreference,
        slowPace: saved.slowPace,
        maxWalkingTime: saved.maxWalkingTime,
      );
    } else {
      _local = ref.read(travelPreferencesProvider);
    }
  }

  void _apply() {
    ref.read(travelPreferencesProvider.notifier).state = _local;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: TSizes.md,
        right: TSizes.md,
        top: TSizes.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: TSizes.md),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text(
            'Preferências do trajeto',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // ── Tipo de rota ─────────────────────────────────────────────────
          Text('Rota', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: TSizes.spaceBtwItems),
          ..._routeOptions(isDark),
          const SizedBox(height: TSizes.spaceBtwSections),

          // ── Caminhada ────────────────────────────────────────────────────
          Text('Caminhada', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: TSizes.spaceBtwItems),
          _walkingDurationRow(context),
          const SizedBox(height: TSizes.spaceBtwItems),
          _walkingPaceRow(context, isDark),
          const SizedBox(height: TSizes.spaceBtwSections),

          // ── Botão aplicar ─────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _apply,
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.dark,
                foregroundColor: TColors.textWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Aplicar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _routeOptions(bool isDark) {
    final options = [
      (label: 'Mais rápida',    icon: Icons.flash_on_outlined,          value: RoutePreference.fastest),
      (label: 'Menos trocas',   icon: Icons.swap_horiz,                 value: RoutePreference.fewerTransfers),
      (label: 'Caminhar menos', icon: Icons.directions_walk_outlined,   value: RoutePreference.leastWalking),
    ];

    return options.map((option) {
      final selected = _local.routePreference == option.value;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? TColors.darkBackground : TColors.lightGrey)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? TColors.primary
                : Colors.grey.withValues(alpha: 0.2),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: RadioListTile<RoutePreference>(
          value: option.value,
          groupValue: _local.routePreference,
          onChanged: (v) {
            if (v != null) setState(() => _local = _local.copyWith(routePreference: v));
          },
          secondary: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: selected ? 1.1 : 1,
            child: Icon(
              option.icon,
              color: selected ? TColors.primary : null,
            ),
          ),
          title: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 16,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? TColors.primary
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
            child: Text(option.label),
          ),
          activeColor: TColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
        ),
      );
    }).toList();
  }

  Widget _walkingDurationRow(BuildContext context) {
    final label = _local.maxWalkingTime >= 60
        ? 'Sem limite'
        : '${_local.maxWalkingTime} min';

    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () => _showDurationPicker(context),
          style: OutlinedButton.styleFrom(
            foregroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            side: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          icon: const Icon(Icons.directions_walk_outlined, size: 18),
          label: const Text('Definir duração'),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _walkingPaceRow(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ritmo de caminhada lento',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Duplica o tempo de cada seção de caminhada',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        Switch(
          value: _local.slowPace,
          activeThumbColor: Colors.white,
          activeTrackColor: TColors.primary,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor:
              isDark ? Colors.black38 : Colors.grey.shade300,
          onChanged: (v) => setState(() => _local = _local.copyWith(slowPace: v)),
        ),
      ],
    );
  }

  void _showDurationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => _DurationPicker(
        initial: _local.maxWalkingTime,
        onConfirm: (v) => setState(() => _local = _local.copyWith(maxWalkingTime: v)),
      ),
    );
  }
}

// ── Picker de duração ─────────────────────────────────────────────────────────

class _DurationPicker extends StatefulWidget {
  final int initial;
  final ValueChanged<int> onConfirm;

  const _DurationPicker({required this.initial, required this.onConfirm});

  @override
  State<_DurationPicker> createState() => _DurationPickerState();
}

class _DurationPickerState extends State<_DurationPicker> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initial.toDouble();
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
            style: Theme.of(context).textTheme.titleMedium,
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
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.soothingLime,
                foregroundColor: TColors.textPrimary,
              ),
              child: const Text('Confirmar'),
            ),
          ),
        ],
      ),
    );
  }
}
