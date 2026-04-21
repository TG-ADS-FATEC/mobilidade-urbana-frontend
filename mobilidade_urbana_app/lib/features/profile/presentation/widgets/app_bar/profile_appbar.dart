
import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/app_bar/edit_profile_icon.dart';
import 'package:mobilidade_urbana_app/utils/shared/widgets/appbar.dart';

class TProfileAppBar extends StatelessWidget {
  const TProfileAppBar({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return TAppBar(
      title: Text("Perfil"),
      actions: [
        TEditProfileIcon(isDark: isDark, onPressed: () {},)
      ],
    );
  }
}
