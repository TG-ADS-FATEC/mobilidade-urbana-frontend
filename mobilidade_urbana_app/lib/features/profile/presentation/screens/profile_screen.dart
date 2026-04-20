import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/profile_appbar.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TProfileAppBar(isDark: isDark),
          ],
        ),
      ),
    );
  }
}


