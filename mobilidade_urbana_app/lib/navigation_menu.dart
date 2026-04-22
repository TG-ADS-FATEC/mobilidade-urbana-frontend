
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
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectIndex.value,
          onDestinationSelected: (index) => controller.selectIndex.value = index,
          backgroundColor: isDarkMode ? TColors.darkBackground : TColors.light,
          indicatorColor: isDarkMode ? TColors.white.withValues(alpha: 0.1) : TColors.black.withValues(alpha: 0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.directions_bus), label: 'Ir'),
            NavigationDestination(icon: Icon(Icons.merge), label: 'Linhas'),
            NavigationDestination(icon: Icon(Icons.account_circle), label: 'Perfil'),

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