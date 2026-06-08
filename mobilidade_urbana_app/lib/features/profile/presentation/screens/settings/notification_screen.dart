import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/core/widgets/appbar.dart';
import 'package:mobilidade_urbana_app/core/widgets/section_heading.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _alertasLinha = true;
  bool _atrasos = true;
  bool _novasRotas = false;
  bool _dicas = false;
  bool _atualizacoes = true;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TAppBar(
              title: const Text('Notificações'),
              showBackArrow: true,
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: TSizes.xs,
                vertical: TSizes.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TSectionHeading(title: 'Transporte'),
                  SizedBox(height: TSizes.spaceBtwItems),
                  _NotifTile(
                    isDark: isDark,
                    icon: Icons.directions_bus_outlined,
                    title: 'Alertas de linha',
                    subtitle: 'Interrupções e mudanças no trajeto.',
                    value: _alertasLinha,
                    onChanged: (v) => setState(() => _alertasLinha = v),
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  SizedBox(height: TSizes.spaceBtwItems),
                  _NotifTile(
                    isDark: isDark,
                    icon: Icons.schedule_outlined,
                    title: 'Atrasos em tempo real',
                    subtitle: 'Notifique quando seu transporte atrasar.',
                    value: _atrasos,
                    onChanged: (v) => setState(() => _atrasos = v),
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                  TSectionHeading(title: 'Conteúdo'),
                  SizedBox(height: TSizes.spaceBtwItems),
                  _NotifTile(
                    isDark: isDark,
                    icon: Icons.route_outlined,
                    title: 'Novas rotas disponíveis',
                    subtitle: 'Quando uma nova linha for adicionada.',
                    value: _novasRotas,
                    onChanged: (v) => setState(() => _novasRotas = v),
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  SizedBox(height: TSizes.spaceBtwItems),
                  _NotifTile(
                    isDark: isDark,
                    icon: Icons.lightbulb_outline_rounded,
                    title: 'Dicas de uso',
                    subtitle: 'Sugestões para aproveitar melhor o app.',
                    value: _dicas,
                    onChanged: (v) => setState(() => _dicas = v),
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                  TSectionHeading(title: 'Sistema'),
                  SizedBox(height: TSizes.spaceBtwItems),
                  _NotifTile(
                    isDark: isDark,
                    icon: Icons.system_update_outlined,
                    title: 'Atualizações do app',
                    subtitle: 'Avise quando houver nova versão disponível.',
                    value: _atualizacoes,
                    onChanged: (v) => setState(() => _atualizacoes = v),
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  const _NotifTile({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.textTheme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? TColors.darkSurface : TColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: TSizes.md,
          color: isDark ? TColors.grey : TColors.darkGrey,
        ),
        title: Text(title, style: textTheme.titleSmall),
        subtitle: Text(subtitle, style: textTheme.bodySmall),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: TColors.primary,
          thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected) ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}
