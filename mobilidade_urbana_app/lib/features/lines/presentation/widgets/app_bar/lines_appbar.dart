import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/core/widgets/appbar.dart';

class TLinesAppBar extends StatelessWidget {
  const TLinesAppBar({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return TAppBar(
      title: const Text('Linhas'),
    );
  }
}
