import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/edit_profile/profile_route_selector.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/edit_profile/profile_transport_selector.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/edit_profile/profile_walking_options.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/core/widgets/appbar.dart';

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
              padding: EdgeInsets.symmetric(
                horizontal: TSizes.xs,
                vertical: TSizes.sm,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const ProfileRouteSelector(),
                  const ProfileTransportSelector(),
                  const ProfileWalkingOptions(),
                  const Text("batata"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}