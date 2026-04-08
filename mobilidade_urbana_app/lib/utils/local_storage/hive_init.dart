import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobilidade_urbana_app/features/onboarding/data/models/onboarding_model.dart';
import 'hive_boxes.dart';

class HiveInit {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(OnboardingModelAdapter());
    await Hive.openBox<OnboardingModel>(HiveBoxes.onboarding);
  }
}