import 'package:hive/hive.dart';
import '../models/onboarding_model.dart';
import '../../../../utils/local_storage/hive_boxes.dart';

class OnboardingLocalDatasource {
  Box<OnboardingModel> get _box =>
      Hive.box<OnboardingModel>(HiveBoxes.onboarding);

  Future<void> save(OnboardingModel data) async {
    await _box.put('data', data);
  }

  OnboardingModel? load() {
    return _box.get('data');
  }

  Future<void> markAsSynced() async {
    final data = _box.get('data');
    if (data == null) return;
    data.isSynced = true;
    await data.save();
  }

  bool get isCompleted => _box.get('data')?.isCompleted ?? false;
  bool get isSynced => _box.get('data')?.isSynced ?? false;
}