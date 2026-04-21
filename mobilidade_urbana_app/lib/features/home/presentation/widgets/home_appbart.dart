
import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/app_bar/edit_profile_icon.dart';
import 'package:mobilidade_urbana_app/utils/shared/widgets/appbar.dart';
import 'package:mobilidade_urbana_app/utils/shared/widgets/notification_menu_icon/notification_menu_icon.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return TAppBar(

      title: Text("Início"),
      actions: [
        TNotificationCounterIcon(isDark: isDark, onPressed: () {},)
      ],
    );
  }
}
