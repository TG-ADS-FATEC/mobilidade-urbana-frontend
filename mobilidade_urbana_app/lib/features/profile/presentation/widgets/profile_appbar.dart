
import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/shared/widgets/notification_menu_icon/notification_menu_icon.dart';
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
        TNotificationCounterIcon(isDark: isDark, onPressed: () {},)
      ],
    );
  }
}
