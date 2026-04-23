
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilidade_urbana_app/features/home/presentation/screens/home_screen.dart';
import 'package:mobilidade_urbana_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget{
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final isDarkMode = THelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
            () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fade gradient on top
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 8),
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        (isDarkMode ? TColors.darkBackground.withValues(alpha: 0.4) : TColors.light).withValues(alpha: 0.4),
                        (isDarkMode ? TColors.darkBackground.withValues(alpha: 0.40) : TColors.light).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDarkMode
                        ? TColors.darkSurface.withValues(alpha: 0.1)
                        : TColors.background.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: NavigationBar(
                height: 80,
                elevation: 0,
                selectedIndex: controller.selectIndex.value,
                onDestinationSelected: (index) => controller.selectIndex.value = index,
                backgroundColor: isDarkMode ? TColors.darkBackground : TColors.light,
                indicatorColor: isDarkMode
                    ? TColors.white.withValues(alpha: 0.1)
                    : TColors.black.withValues(alpha: 0.1),
                destinations: [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.directions_bus_outlined),
                    selectedIcon: Icon(Icons.directions_bus),
                    label: 'Ir',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.merge_outlined),
                    selectedIcon: Icon(Icons.merge),
                    label: 'Linhas',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.account_circle_outlined),
                    selectedIcon: Icon(Icons.account_circle),
                    label: 'Perfil',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectIndex.value]),
    );
  }
}

class NavigationController extends GetxController{
  final Rx<int> selectIndex = 0.obs;

  final screens = [HomeScreen(), Container(color: Colors.blue), Container(color: Colors.red), ProfileScreen()];
}