import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/controllers/preferences_controller.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/edit_profile/profile_route_selector.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/edit_profile/profile_transport_selector.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/edit_profile/profile_walking_options.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/core/widgets/appbar.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PreferencesController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TAppBar(
              title: const Text("Editar Perfil"),
              showBackArrow: true,
              actions: [
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  if (controller.isSaved.value) {
                    return const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Row(
                        children: [
                          Text("Salvo", style: TextStyle(color: Colors.green)),
                          SizedBox(width: 4),
                          Icon(Icons.check_circle, color: Colors.green),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: TSizes.xs,
                vertical: TSizes.sm,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  ProfileRouteSelector(),
                  const ProfileTransportSelector(),
                  const ProfileWalkingOptions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}