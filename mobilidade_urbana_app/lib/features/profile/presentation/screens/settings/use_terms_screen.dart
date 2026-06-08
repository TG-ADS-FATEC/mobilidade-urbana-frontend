import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/core/widgets/appbar.dart';

class UseTermsScreen extends StatefulWidget {
  const UseTermsScreen({super.key});

  @override
  State<UseTermsScreen> createState() => _UseTermsScreenState();
}

class _UseTermsScreenState extends State<UseTermsScreen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    const green = TColors.primary;

    return Scaffold(
      body: Column(
        children: [
          TAppBar(
            title: const Text('Termos de uso'),
            showBackArrow: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: TSizes.sm,
                vertical: TSizes.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.insert_drive_file_outlined,
                            color: green, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Termos de Uso',
                                  style: textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              Text('Última atualização: junho de 2025',
                                  style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  _Section(
                    title: '1. Aceitação dos Termos',
                    body:
                        'Ao utilizar o aplicativo Mobilidade Urbana, você concorda com estes Termos de Uso. Caso não concorde com alguma parte, recomendamos que interrompa o uso do aplicativo.',
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  _Section(
                    title: '2. Uso do Serviço',
                    body:
                        'O aplicativo é fornecido para auxiliar no planejamento de rotas de transporte público. As informações exibidas são baseadas em dados públicos e podem apresentar variações em relação à situação real do transporte.',
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  _Section(
                    title: '3. Coleta de Dados',
                    body:
                        'Coletamos dados de localização e uso para melhorar a experiência do usuário. Esses dados são tratados de acordo com nossa Política de Privacidade e a Lei Geral de Proteção de Dados (LGPD – Lei nº 13.709/2018).',
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  _Section(
                    title: '4. Responsabilidades',
                    body:
                        'Não nos responsabilizamos por atrasos, cancelamentos ou mudanças nos serviços de transporte público. O usuário é responsável pelo uso adequado do aplicativo e pelas decisões tomadas com base nas informações fornecidas.',
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  _Section(
                    title: '5. Propriedade Intelectual',
                    body:
                        'Todo o conteúdo do aplicativo, incluindo código, design e logotipos, é de propriedade exclusiva da equipe Mobilidade Urbana. É proibida a reprodução sem autorização prévia.',
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  _Section(
                    title: '6. Alterações nos Termos',
                    body:
                        'Reservamos o direito de modificar estes Termos a qualquer momento. Alterações significativas serão comunicadas via notificação no aplicativo. O uso continuado após as alterações implica aceitação dos novos termos.',
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  _Section(
                    title: '7. Contato',
                    body:
                        'Dúvidas sobre estes Termos podem ser enviadas para gustavo@mobilidadeurbana.app.',
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
          ),
          // Accept button
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _accepted,
                      onChanged: (v) => setState(() => _accepted = v ?? false),
                      activeColor: green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    Expanded(
                      child: Text(
                        'Li e aceito os Termos de Uso',
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _accepted
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Termos aceitos com sucesso!'),
                                backgroundColor: TColors.primary,
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: green,
                      disabledBackgroundColor:
                          colorScheme.onSurface.withOpacity(0.12),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Aceitar e continuar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  const _Section({
    required this.title,
    required this.body,
    required this.textTheme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            body,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
