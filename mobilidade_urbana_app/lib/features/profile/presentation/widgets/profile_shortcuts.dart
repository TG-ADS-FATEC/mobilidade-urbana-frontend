import 'package:flutter/material.dart';
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
      child: Column(
        children: [
          TSectionHeading(title: 'Configurações'),
          SizedBox(height: TSizes.spaceBtwItems),
          TSettingsMenuTile(icon: Icons.download_outlined, title: 'Atualização disponível', subtitle: 'v1.2.2', onTap: () {}),
        ],
      )

    );
  }
}