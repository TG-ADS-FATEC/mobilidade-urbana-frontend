
import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';
import 'package:mobilidade_urbana_app/utils/constants/text_sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
                children: [
                  Expanded(
                    child:
                      const Text(
                        'Perfil',
                        style: TextStyle(
                          fontSize: TTextSizes.titleLarge,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                  ),
                ]
            ),
          ),
      )
    );
  }
}