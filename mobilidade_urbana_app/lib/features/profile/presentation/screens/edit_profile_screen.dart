import 'package:flutter/material.dart';

import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';
import 'package:mobilidade_urbana_app/utils/shared/widgets/appbar.dart';


class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TAppBar(
              title: Text("Editar Perfil"),
              showBackArrow: true,
            ),
            Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: TSizes.xs, vertical: TSizes.sm),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}




