import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionService {
  static const _key = 'permissions_requested';

  static Future<bool> _hasRequested() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> requestOnFirstLaunch(BuildContext context) async {
    if (await _hasRequested()) return;

    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _PermissionRationaleDialog(),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);

    if (confirmed != true) return;

    await [
      Permission.locationWhenInUse,
      Permission.notification,
    ].request();
  }

  static Future<bool> isLocationGranted() async {
    final status = await Permission.locationWhenInUse.status;
    return status.isGranted;
  }
}

class _PermissionRationaleDialog extends StatelessWidget {
  const _PermissionRationaleDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Antes de começar',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Para oferecer a melhor experiência, o app precisa de acesso a:',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          SizedBox(height: 16),
          _PermissionItem(
            icon: Icons.location_on_outlined,
            title: 'Localização',
            description:
                'Para mostrar sua posição no mapa e sugerir rotas a partir de onde você está.',
          ),
          SizedBox(height: 12),
          _PermissionItem(
            icon: Icons.notifications_outlined,
            title: 'Notificações',
            description:
                'Para avisar sobre horários de embarque e atualizações de rota.',
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Permitir acesso'),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Agora não'),
          ),
        ),
      ],
    );
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
