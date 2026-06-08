import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';
import 'package:mobilidade_urbana_app/core/widgets/appbar.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _locationData = true;
  bool _usageAnalytics = false;
  bool _crashReports = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    const green = TColors.primary;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TAppBar(
              title: const Text('Dados e Privacidade'),
              showBackArrow: true,
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: TSizes.sm,
                vertical: TSizes.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Text('Coleta de dados', style: textTheme.titleMedium),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _PrivacyToggle(
                    icon: Icons.location_on_outlined,
                    title: 'Dados de localização',
                    subtitle: 'Usados para calcular rotas personalizadas.',
                    value: _locationData,
                    onChanged: (v) => setState(() => _locationData = v),
                    activeColor: green,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _PrivacyToggle(
                    icon: Icons.analytics_outlined,
                    title: 'Análise de uso',
                    subtitle: 'Ajuda a melhorar o aplicativo.',
                    value: _usageAnalytics,
                    onChanged: (v) => setState(() => _usageAnalytics = v),
                    activeColor: green,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _PrivacyToggle(
                    icon: Icons.bug_report_outlined,
                    title: 'Relatórios de falhas',
                    subtitle: 'Envia dados automáticos quando há erros.',
                    value: _crashReports,
                    onChanged: (v) => setState(() => _crashReports = v),
                    activeColor: green,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Text('Seus dados', style: textTheme.titleMedium),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _DataActionTile(
                    icon: Icons.download_outlined,
                    title: 'Exportar meus dados',
                    subtitle: 'Receba uma cópia de todas as suas informações.',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _DataActionTile(
                    icon: Icons.delete_sweep_outlined,
                    title: 'Apagar histórico de viagens',
                    subtitle: 'Remove o histórico de rotas realizadas.',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    isDestructive: true,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Center(
                    child: Text(
                      'Última atualização: junho de 2025',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _PrivacyToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.activeColor,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkSurface : TColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: isDark ? TColors.grey : TColors.darkGrey, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
            thumbColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected) ? Colors.white : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _DataActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final bool isDestructive;

  const _DataActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colorScheme,
    required this.textTheme,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final iconColor = isDestructive ? colorScheme.error : (isDark ? TColors.grey : TColors.darkGrey);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkSurface : TColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? colorScheme.error : null,
                    )),
                Text(subtitle,
                    style: textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
