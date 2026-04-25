import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/core/widgets/appbar.dart';


class UseTermsScreen extends StatelessWidget {
  const UseTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TAppBar(
              title: Text("Termos de uso"),
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




