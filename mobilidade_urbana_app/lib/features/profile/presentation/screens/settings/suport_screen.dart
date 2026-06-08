import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';
import 'package:mobilidade_urbana_app/core/widgets/appbar.dart';

class SuportScreen extends StatelessWidget {
  const SuportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TAppBar(
              title: const Text('Suporte'),
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
                  const SizedBox(height: TSizes.spaceBtwItems),
                  // Contact card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          TColors.primary.withOpacity(0.15),
                          colorScheme.surface,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: TColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: const AssetImage('assets/images/suporte.png'),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Gustavo',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Desenvolvedor & Suporte',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        _ContactRow(
                          icon: Icons.email_outlined,
                          label: 'E-mail',
                          value: 'gustavo@mobilidadeurbana.app',
                          onTap: () {
                            Clipboard.setData(
                              const ClipboardData(text: 'gustavo@mobilidadeurbana.app'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('E-mail copiado!')),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _ContactRow(
                          icon: Icons.phone_outlined,
                          label: 'Telefone',
                          value: '+55 (11) 95416-6082',
                          onTap: () {
                            Clipboard.setData(
                              const ClipboardData(text: '+55 (11) 95416-6082'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Telefone copiado!')),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _ContactRow(
                          icon: Icons.code_rounded,
                          label: 'GitHub',
                          value: 'github.com/GustavoRodrigues476',
                          onTap: () {
                            Clipboard.setData(
                              const ClipboardData(text: 'https://github.com/GustavoRodrigues476'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Link copiado!')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Text('Como podemos ajudar?', style: textTheme.titleMedium),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _FaqTile(
                    icon: Icons.bug_report_outlined,
                    title: 'Reportar um bug',
                    subtitle: 'Encontrou algum problema? Nos conte.',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _FaqTile(
                    icon: Icons.lightbulb_outline_rounded,
                    title: 'Sugerir melhoria',
                    subtitle: 'Tem uma ideia? Adoramos ouvir.',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _FaqTile(
                    icon: Icons.quiz_outlined,
                    title: 'Dúvidas frequentes',
                    subtitle: 'Respostas para as perguntas mais comuns.',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Center(
                    child: Text(
                      'Versão 1.2.2 · Mobilidade Urbana',
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

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: TColors.primary),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    )),
                Text(value,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
            const Spacer(),
            Icon(Icons.copy_rounded,
                size: 16, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _FaqTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.all(14),
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
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    )),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
