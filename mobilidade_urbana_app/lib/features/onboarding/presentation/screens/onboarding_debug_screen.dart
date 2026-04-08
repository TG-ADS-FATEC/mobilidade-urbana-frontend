import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:mobilidade_urbana_app/utils/device/device_token_service.dart';

class OnboardingDebugPage extends StatefulWidget {
  const OnboardingDebugPage({super.key});

  @override
  State<OnboardingDebugPage> createState() => _OnboardingDebugPageState();
}

class _OnboardingDebugPageState extends State<OnboardingDebugPage> {
  final _local = OnboardingLocalDatasource();
  String _token = '';

  @override
  void initState() {
    super.initState();
    DeviceTokenService.get().then((t) => setState(() => _token = t));
  }

  @override
  Widget build(BuildContext context) {
    final data = _local.load();

    return Scaffold(
      appBar: AppBar(title: const Text('Debug — Onboarding')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: data == null
            ? const Center(child: Text('Nenhum dado salvo no Hive'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row('Device Token', _token),
                  _row('Transportes', data.transportPreferences.join(', ')),
                  _row('Preferência de rota', data.selectedRoutePreference),
                  _row('Caminhada lenta', data.slowWalkingPace.toString()),
                  _row('Duração caminhada', '${data.walkingDuration} min'),
                  _row('Sincronizado', data.isSynced.toString()),
                  _row('Completo', data.isCompleted.toString()),

                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () async {
                      final current = _local.load();
                      if (current == null) return;
                      current.isSynced = false;
                      await _local.save(current);
                      setState(() {});
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Resetado para pendente')),
                      );
                    },
                    child: const Text('Resetar sincronizado → false'),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 180,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      );
}