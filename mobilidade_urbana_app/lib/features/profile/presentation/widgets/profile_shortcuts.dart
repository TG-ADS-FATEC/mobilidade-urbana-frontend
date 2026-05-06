import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilidade_urbana_app/core/widgets/confirm_dialog.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/settings/historic_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/settings/notification_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/settings/privacy_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/settings/suport_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/settings/use_terms_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/deletion/settings_menu_deletion_tile.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/settings_menu_tile.dart';
import 'package:mobilidade_urbana_app/core/widgets/section_heading.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

class ProfileShortcuts extends ConsumerWidget {
  const ProfileShortcuts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      profileControllerProvider.select((s) => s.navigateToWelcome),
      (prev, next) {
        if (next) {
          ref.read(profileControllerProvider.notifier).clearNavigation();
          context.go('/welcome');
        }
      },
    );

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: TSizes.xs),
        child: Column(
          children: [
            TSectionHeading(title: 'Configurações'),
            SizedBox(height: TSizes.spaceBtwItems),
            ...[
              TSettingsMenuTile(
                icon: Icons.manage_accounts_outlined,
                title: 'Editar perfil',
                subtitle: 'Altere suas informações',
                onTap: () => context.push('/profile/edit-profile'),
              ),
              TSettingsMenuTile(
                icon: Icons.history_rounded,
                title: 'Minhas Atividades',
                subtitle: 'Acompanhe seu uso no app',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HistoricScreen()),
                ),
              ),
              TSettingsMenuTile(
                icon: Icons.edit_notifications_outlined,
                title: 'Notificações',
                subtitle: 'Controle avisos e alertas',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NotificationScreen()),
                ),
              ),
              TSettingsMenuTile(
                icon: Icons.support_agent_rounded,
                title: 'Suporte',
                subtitle: 'Fale com a gente',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SuportScreen()),
                ),
              ),
              TSettingsMenuTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Dados e Privacidade',
                subtitle: 'Gerencie suas informações',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                ),
              ),
              TSettingsMenuTile(
                icon: Icons.download_outlined,
                title: 'Atualização disponível',
                subtitle: 'v1.2.2',
                onTap: () {},
              ),
            ].expand((widget) => [widget, SizedBox(height: TSizes.spaceBtwItems)]),
            SizedBox(height: TSizes.spaceBtwSections),
            TSectionHeading(title: 'Privacidade'),
            SizedBox(height: TSizes.spaceBtwItems),
            ...[
              TSettingsMenuTile(
                icon: Icons.analytics_outlined,
                title: 'Permitir monitoramento',
                subtitle: 'Coleta para melhorias',
                onTap: () {},
                trailing: Switch(value: true, onChanged: (value) {}),
              ),
              TSettingsMenuTile(
                icon: Icons.insert_drive_file_outlined,
                title: 'Termos de Uso',
                subtitle: 'Acompanhe seu uso no app',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const UseTermsScreen()),
                ),
              ),
              TSettingsMenuDeletionTile(
                icon: Icons.delete_outline,
                title: 'Excluir conta',
                subtitle: 'Apaga todos seus dados',
                onTap: () => _confirmDelete(context, ref),
              ),
            ].expand((widget) => [widget, SizedBox(height: TSizes.spaceBtwItems)]),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Excluir conta',
      message: 'Tem certeza? Essa ação não pode ser desfeita.',
      confirmText: 'Excluir',
      isDangerous: true,
    );
    if (confirmed == true) {
      ref.read(profileControllerProvider.notifier).deleteProfile();
    }
  }
}
