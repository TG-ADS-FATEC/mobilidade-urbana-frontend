
import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/core/widgets/appbar.dart';
import 'package:mobilidade_urbana_app/core/widgets/notification_menu_icon/notification_menu_icon.dart';

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
