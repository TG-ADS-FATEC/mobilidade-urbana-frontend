import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';
import 'package:mobilidade_urbana_app/utils/shared/widgets/section_heading.dart';

class ProfileStats extends StatelessWidget {
  final int traveledKm;
  final int totalPoints;
  final int hikingKm;
  final int tripsMade;

  const ProfileStats({
    super.key,
    required this.traveledKm,
    required this.totalPoints,
    required this.hikingKm,
    required this.tripsMade,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: TSizes.xs),
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
                iconColor: Colors.grey,
                value: '$traveledKm',
                label: 'Km viajados',
              ),
              _StatCard(
                icon: Icons.star_rounded,
                iconColor: const Color(0xFFFFCC00),
                value: '$totalPoints',
                label: 'Pontos ganhos',
                highlighted: true,
              ),
              _StatCard(
                icon: Icons.hiking_outlined,
                iconColor: Colors.grey,
                value: '$hikingKm',
                label: 'Km caminhados',
              ),
              _StatCard(
                icon: Icons.timelapse,
                iconColor: Colors.grey,
                value: '$tripsMade',
                label: 'Viagens feitas',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool highlighted;
  final bool smallValue;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.highlighted = false,
    this.smallValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = THelperFunctions.isDarkMode(context);

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
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: smallValue ? 15 : 20,
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
          )

        ],
      ),
    );
  }
}