import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/controllers/preferences_controller.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/edit_profile/profile_route_selector.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/edit_profile/profile_transport_selector.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/widgets/edit_profile/profile_walking_options.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/core/widgets/appbar.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(preferencesControllerProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TAppBar(
              title: const Text('Editar Perfil'),
              showBackArrow: true,
              actions: [
                if (state.isLoading && state.preferences != null)
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else if (state.isSaved)
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(
                      children: [
                        Text('Salvo', style: TextStyle(color: Colors.green)),
                        SizedBox(width: 4),
                        Icon(Icons.check_circle, color: Colors.green),
                      ],
                    ),
                  ),
              ],
            ),
            if (state.isLoading && state.preferences == null)
              const Padding(
                padding: EdgeInsets.only(top: 80),
                child: CircularProgressIndicator(),
              )
            else if (state.preferences == null)
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_off_outlined,
                        size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Não foi possível carregar as preferências',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () => ref
                          .read(preferencesControllerProvider.notifier)
                          .loadPreferences(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: TSizes.sm,
                  vertical: TSizes.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Text(
                      'Preferências de rota',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const ProfileRouteSelector(),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Text(
                      'Modos de transporte',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Os tipos selecionados terão prioridade mais alta no trajeto sugerido',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const ProfileTransportSelector(),
                    const SizedBox(height: TSizes.spaceBtwSections),
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
