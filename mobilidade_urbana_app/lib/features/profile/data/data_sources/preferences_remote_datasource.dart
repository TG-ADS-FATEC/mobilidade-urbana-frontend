

import 'package:mobilidade_urbana_app/features/profile/data/models/preferences_model.dart';

abstract class PreferencesRemoteDatasource {
  Future<PreferencesModel> getPreferences();
  Future<PreferencesModel> updatePreferences();
  Future<void> deletePreferences();

}
