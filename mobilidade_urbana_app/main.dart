import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/device/device_register_service.dart';
import 'package:mobilidade_urbana_app/utils/device/device_token_service.dart';
import 'package:mobilidade_urbana_app/utils/local_storage/hive_init.dart';
import 'features/onboarding/services/onboarding_hive_service.dart';
import 'features/onboarding/services/onboarding_api_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // runApp(const SplashScreen());

  await Future.wait([
     HiveInit.init(),
     DeviceTokenService.get(),
     DeviceRegisterService.register(),
  ]);


  runApp(const App());
}