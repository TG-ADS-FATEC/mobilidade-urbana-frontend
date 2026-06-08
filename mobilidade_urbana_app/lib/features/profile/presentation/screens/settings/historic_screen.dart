import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/core/widgets/appbar.dart';
import 'package:mobilidade_urbana_app/core/widgets/section_heading.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class HistoricScreen extends StatelessWidget {
  const HistoricScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TAppBar(
              title: const Text('Minhas atividades'),
              showBackArrow: true,
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: TSizes.xs,
                vertical: TSizes.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TSectionHeading(title: 'Minhas Estatísticas'),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.5,
                    children: [
                      _StatCard(
                        icon: Icons.directions_bus_outlined,
                        iconColor: TColors.grey,
                        value: '8',
                        label: 'Viagens feitas',
                        isDark: isDark,
                      ),
                      _StatCard(
                        icon: Icons.star_rounded,
                        iconColor: const Color(0xFFFFCC00),
                        value: '240',
                        label: 'Pontos ganhos',
                        isDark: isDark,
                      ),
                      _StatCard(
                        icon: Icons.route_outlined,
                        iconColor: TColors.grey,
                        value: '24',
                        label: 'Km viajados',
                        isDark: isDark,
                      ),
                      _StatCard(
                        icon: Icons.hiking_outlined,
                        iconColor: TColors.grey,
                        value: '14',
                        label: 'Km caminhados',
                        isDark: isDark,
                      ),
                    ],
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                  TSectionHeading(title: 'Histórico recente'),
                  SizedBox(height: TSizes.spaceBtwItems),
                  ..._trips.map(
                    (trip) => _TripTile(trip: trip, isDark: isDark),
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _trips = [
  _TripData(
    origin: 'Av. Paulista',
    destination: 'Aeroporto de Congonhas',
    date: 'Hoje, 08:42',
    km: '12 km',
    duration: '38 min',
    transport: Icons.directions_subway_rounded,
  ),
  _TripData(
    origin: 'Estação Consolação',
    destination: 'Shopping Ibirapuera',
    date: 'Ontem, 19:15',
    km: '6 km',
    duration: '22 min',
    transport: Icons.directions_bus_rounded,
  ),
  _TripData(
    origin: 'Terminal Bandeira',
    destination: 'Parque do Ibirapuera',
    date: '04/06, 14:00',
    km: '4 km',
    duration: '18 min',
    transport: Icons.tram_rounded,
  ),
  _TripData(
    origin: 'Estação Sé',
    destination: 'Estação Tatuapé',
    date: '02/06, 09:30',
    km: '8 km',
    duration: '28 min',
    transport: Icons.directions_subway_rounded,
  ),
];

class _TripData {
  final String origin;
  final String destination;
  final String date;
  final String km;
  final String duration;
  final IconData transport;

  const _TripData({
    required this.origin,
    required this.destination,
    required this.date,
    required this.km,
    required this.duration,
    required this.transport,
  });
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? TColors.darkSurface : TColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 36),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TripTile extends StatelessWidget {
  final _TripData trip;
  final bool isDark;

  const _TripTile({required this.trip, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? TColors.darkSurface : TColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: Icon(
            trip.transport,
            size: TSizes.md,
            color: isDark ? TColors.grey : TColors.darkGrey,
          ),
          title: Text(
            trip.destination,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          subtitle: Text(
            '${trip.origin} · ${trip.date}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                trip.km,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                trip.duration,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
