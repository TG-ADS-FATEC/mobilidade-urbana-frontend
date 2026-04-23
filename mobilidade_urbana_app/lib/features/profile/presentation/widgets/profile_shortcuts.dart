import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/settings/historic_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/settings/notification_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/settings/privacy_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/settings/suport_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/settings/use_terms_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/deletion/settings_menu_deletion_tile.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/settings_menu_tile.dart';
import 'package:mobilidade_urbana_app/utils/shared/widgets/section_heading.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

class ProfileShortcuts extends StatelessWidget {
  const ProfileShortcuts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: TSizes.xs),
        child: Column(
          children: [
            TSectionHeading(title: 'Configurações'),
            SizedBox(height: TSizes.spaceBtwItems),
            ...[
              TSettingsMenuTile(icon: Icons.manage_accounts_outlined, title: 'Editar perfil', subtitle: 'Altere suas informações', onTap: () =>  Get.to(() => const EditProfileScreen())),
              TSettingsMenuTile(icon: Icons.history_rounded, title: 'Minhas Atividades', subtitle: 'Acompanhe seu uso no app', onTap: () =>  Get.to(() => const HistoricScreen())),
              TSettingsMenuTile(icon: Icons.edit_notifications_outlined, title: 'Notificações', subtitle: 'Controle avisos e alertas', onTap: () =>  Get.to(() => const NotificationScreen())),
              TSettingsMenuTile(icon: Icons.support_agent_rounded, title: 'Suporte', subtitle: 'Fale com a gente', onTap: () =>  Get.to(() => const SuportScreen())),
              TSettingsMenuTile(icon: Icons.privacy_tip_outlined, title: 'Dados e Privacidade', subtitle: 'Gerencie suas informações', onTap: () => Get.to(() => const PrivacyScreen())),
              TSettingsMenuTile(icon: Icons.download_outlined, title: 'Atualização disponível', subtitle: 'v1.2.2', onTap: () {}),
            ].expand((widget) => [widget, SizedBox(height: TSizes.spaceBtwItems)]),
            SizedBox(height: TSizes.spaceBtwSections),
            TSectionHeading(title: 'Privacidade'),
            SizedBox(height: TSizes.spaceBtwItems),
            ...[
              TSettingsMenuTile(icon: Icons.analytics_outlined, title: 'Permitir monitoramente', subtitle: 'Coleta para melhorias', onTap: () {}, trailing: Switch(value: true, onChanged: (value) {}),),
              TSettingsMenuTile(icon: Icons.insert_drive_file_outlined, title: 'Termos de Uso', subtitle: 'Acompanhe seu uso no app', onTap: () => Get.to(() => const UseTermsScreen())),
              TSettingsMenuDeletionTile(icon: Icons.delete_outline, title: 'Excluir conta', subtitle: 'Apaga todos seus dados', onTap: () {}),
            ].expand((widget) => [widget, SizedBox(height: TSizes.spaceBtwItems)]),
          ],
        ),
      )

    );
  }
}